Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3967E41A519;
	Wed, 22 Jul 2026 16:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784737293; cv=none; b=prSqraZQcX125UI9L4fbGiP6G/J31pW6XeI6HG5gG0XAhKTB//QdWs9cOb6ZOj6X9InKbJkJHIXxuAD39yqfzRlo8FZJsacPcBCj0tpnq9YEbudXyZXs6W8tTW7OgFyWndJHHkZSTBXE6XI+SSY9xN51LGjc4YZ+BmZ9V36i6cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784737293; c=relaxed/simple;
	bh=xLkhrxB7oigARYLEymH4Neo5D/LV3BCUfYFz16dUitA=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=siNlt5aQlpormHi8rPfbDSF8mWGrU0CRA8jFPxLy/qr8alxBTSuqzZJ9EhScsPimInaLZcz+neei31zV6YT7ePSYeB4q2ymuKyWkPyp71LzJ76XDKY+/p0ZJAbwFEnYthlWJO5aL3pn3oXTZcZjnhxbWf+BmcmDXork3KbNXb9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gLVNQNNW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gLVNQNNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D171F000E9;
	Wed, 22 Jul 2026 16:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784737291;
	bh=VwnfcW/GPGjtHfzKnzfOgLY42ndUHYSaKu3CI0yv0bU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=gLVNQNNWDIPt0G4F8oX9PxVU5L5UmAykEKvBSlT62TOMRjlq7JMXxJmPy77O/rFe2
	 rw2jrniFbA0HDemp+9UEnMNIeUBHDXRK4dain665wyKyc7LGn+cP80tA39FUULPIKl
	 ipTDPq7sg928TAk/RCE7Hv7UiCGdMnZY3/YgrHkpVforFPxxIJFz3KF25TU9LowdVg
	 y0+7mqTJLQXW+xh3OiqlLpmyh54W6/am9+UQgAqffO3io+8sTMKO69h9qs2fN+fHe4
	 LWEWywhlERyUpQjHH9LslBiO1Z2QQxmyMZmH9fIGzq6ITuSuCg0TD8qHJ0Yrn0KLCo
	 YiLZ3u6ZfK4uA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93A07380AA76;
	Wed, 22 Jul 2026 16:21:01 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] wireless-2026-07-22
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178473726040.1922397.17312449940002537230.git-patchwork-notify@kernel.org>
Date: Wed, 22 Jul 2026 16:21:00 +0000
References: <20260722092647.119094-3-johannes@sipsolutions.net>
In-Reply-To: <20260722092647.119094-3-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 22 Jul 2026 11:24:38 +0200 you wrote:
> Hi,
> 
> So unfortunately this is really big, in part due to the
> conference last week which caused me to miss that week,
> but also mostly recentlky drivers coming with alrge pull
> requests with a whole lot of security/robustness fixes.
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] wireless-2026-07-22
    https://git.kernel.org/netdev/net/c/fec15bb3dab0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


