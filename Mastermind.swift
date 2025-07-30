import Foundation

// تولید کد مخفی تصادفی
func generateSecretCode() -> [Int] {
    return (0..<4).map { _ in Int.random(in: 1...6) }
}

// خواندن حدس از کاربر
func readGuess() -> [Int]? {
    print("یک عدد ۴ رقمی (هر رقم بین ۱ تا ۶) وارد کنید (یا 'exit' برای خروج): ", terminator: "")
    guard let line = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else {
        return nil
    }
    if line.lowercased() == "exit" {
        print("خداحافظ!")
        exit(0)
    }
    guard line.count == 4, line.allSatisfy({ "123456".contains($0) }) else {
        print("ورودی نامعتبر است. سعی کنید دوباره.")
        return readGuess()
    }
    return line.compactMap { Int(String($0)) }
}

// محاسبه مهره‌های سیاه و سفید
func evaluate(guess: [Int], secret: [Int]) -> (black: Int, white: Int) {
    var black = 0, white = 0
    var secretCounts = [Int: Int]()
    var guessCounts = [Int: Int]()

    // شمردن مهره‌های سیاه و جمع‌آوری بقیه برای محاسبه سفید
    for i in 0..<4 {
        if guess[i] == secret[i] {
            black += 1
        } else {
            secretCounts[secret[i], default: 0] += 1
            guessCounts[guess[i], default: 0] += 1
        }
    }

    // برای هر رقم، تعداد مشترک بین guessCounts و secretCounts می‌شود مهره سفید
    for (digit, gCount) in guessCounts {
        let sCount = secretCounts[digit] ?? 0
        white += min(gCount, sCount)
    }

    return (black, white)
}

// حلقه اصلی بازی
func playMastermind() {
    let secret = generateSecretCode()
    print("=== بازی Mastermind ===")
    // Uncomment کنید برای دیباگ:
//    print("کد مخفی: \(secret.map(String.init).joined())")
    while true {
        guard let guess = readGuess() else { continue }
        let (b, w) = evaluate(guess: guess, secret: secret)
        let response = String(repeating: "B", count: b) + String(repeating: "W", count: w)
        print("پاسخ: \(response) (\(b) مهره سیاه، \(w) مهره سفید)")
        if b == 4 {
            print("تبریک! کد مخفی را پیدا کردید.")
            break
        }
    }
}

playMastermind()

