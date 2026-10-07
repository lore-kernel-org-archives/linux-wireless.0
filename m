Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9C6419315;
	Wed,  7 Oct 2026 23:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791415813; cv=none; b=sa4sVnhXwv0Why4Z3KbKjXgLNG1XBkgt4IHlyazJjATuDzZoRKXG8t6qXG9xd1Nm62FAVb4DTUPwdi9/CnHgjf+N8+8nPrLp7B2SY+mwqUyoB9wrxHHqoX2hMcknYzOKVQuZWTPGGbFxEcudfFRbw7+frbMgy7GjC5Xf5x8roWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791415813; c=relaxed/simple;
	bh=VHZAgTRouiaUkKjWo4HplGeWMWN8PjRFD3Ae3DIsFcc=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=ktOUedLZlDoqceQKo1XU2ZZpHtrMYLHNdznznlUxGBvs4+uELwD7DCNhl49UbldzdxzK8Ad6qq+jmFrgdXbLT/Rm/FUiZXYUvUQkN2SZN2aFBeEyL7b6tyeliqVziaX9eaAe4A9R0fk7LaniGSk/MLeBDiNshXGtbX/Qo3vIjHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DOlt18E0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DOlt18E0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C301F000FF;
	Wed,  7 Oct 2026 23:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791415809;
	bh=UnWprGdsd1NbeiDvfh0t32/tyVH77xuaT9ndMymh3/w=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=DOlt18E0yeHXZjbEvfWhcmMyn9f9KwXYNd6hjetyE5OWfoKp3KDBugddRLQcEqUyd
	 acu5fy8c11LpDgbnrS4YGrBkd6cOTq5R6ZqT+rZDQg9npUVAyNHVsld4zSwBZbvus2
	 f6kGdVReaLOu+SKkWlNWJ8E2pSFP/SF8U6g7MzZwLjhMs+H+8rstqtfqy7Ja7B5XtX
	 N95QgccF1yofYYfCuUmJYPbvMt6dgcf2DHq8RetSgjR7VPpWi8X9jqN/BSBN2Eha36
	 ihw6RfF6wuUpWnxkMc56hDPrLpKEjDQzI2eTD888zIqG3m4Z5thT/65SkcEdsMjWGU
	 WVF3UzjGchRVA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A3893809A08;
	Wed,  7 Oct 2026 23:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] wireless-2026-10-07
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179141580803.3733694.16381283704813319926.git-patchwork-notify@kernel.org>
Date: Wed, 07 Oct 2026 23:30:08 +0000
References: <20261007205143.464714-3-johannes@sipsolutions.net>
In-Reply-To: <20261007205143.464714-3-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  7 Oct 2026 22:49:59 +0200 you wrote:
> Hi,
> 
> So ... I pushed back as hard as I could, and Felix reduced
> by ~25 patches, and I told everyone I need to get fixes much
> earlier in the cycle.
> 
> Nevertheless, I ended up with 25 fixes (not counting merges).
> Hope that's OK, otherwise we'll try to whittle it down more.
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] wireless-2026-10-07
    https://git.kernel.org/netdev/net/c/fd4e7f113729

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


