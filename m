Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E4D44F553;
	Wed, 30 Sep 2026 21:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790803211; cv=none; b=mdLAS4n4cfiZfnioAj54m1N+c5PxeSH/hvmIDf9VONx1/CQxyJVkGVh0N4gq5Ub0ZO8RYJfUxaiheov82hrNykh8/gFUdz+QgEawLO/C0qL5YX2cfy0AmXcMmwx3QA6WZi503S+iIYfJhUVlcPbcQPH0DKLq2a6p9ee618Ol9aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790803211; c=relaxed/simple;
	bh=TqVsQlfHRJaOud3l8d0u+zBvA5xZXEYu5+uVN12FiCE=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=kYqlYlvBSxnaqItmBB/E9b0UJHcXkIUOU8Mo3AWX+OLTjp04xkPPn1NqxUS/WaQsiMQzs45qwJUykVSRdRxfcfFrB6xT9JbXz9q2N+8JFFzlAbz5oQna7wGpddOfLa6Rjd0353+Me1CaxneZoFf4h/jR3RGzI4cJNJMvfKAzVCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IaKKTLcw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IaKKTLcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FC1C1F000FF;
	Wed, 30 Sep 2026 21:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790803209;
	bh=gDlym5Tf97SG9JIIGmk277kdxEo0BcB5zIq/Oj+NXGo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=IaKKTLcwidjyq7MfgZvjN1BJEmu+4+VqSbFLTPNoAp7suj5rtb9ZjsEdsuXPPSChE
	 6xJyqHVby4no7YOIvR7uENUK/dQ4YovHMcyZQxI4OGditFVZK1g5pa3vIzhnps/sKV
	 viI3ewFsHt9ouChlfTASys8EUndY06ocByncudmHub+IAnBTY4Z5uIwW9rpiI3R9Ng
	 Fvhtfsnl4Z03NAJeNPzUh+HRWXo6AO9SwagUMgxwK4dCn6qvLvgF/3TOh6A2nFRPEy
	 kRtdpWB2CGRBTrkKnoUva4H/B9pLdxMlniDobsB8ENFpOHLJDGVx+KW/9/GRPEGqtV
	 NF7LQFgQDejOg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 773463A56772;
	Wed, 30 Sep 2026 21:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] wireless-2026-09-30
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179080320828.2132795.4482453098537872906.git-patchwork-notify@kernel.org>
Date: Wed, 30 Sep 2026 21:20:08 +0000
References: <20260930124440.224799-3-johannes@sipsolutions.net>
In-Reply-To: <20260930124440.224799-3-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 30 Sep 2026 14:43:00 +0200 you wrote:
> Hi,
> 
> Things aren't really slowing down by that much, unfortunately, but
> these are mostly fairlyh obvious changes.
> 
> Note there will be a merge conflict with ieee80211_lookup_ra_sta()
> when this gets pulled into net-next which made it static, and here
> we add another argument to the function.
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] wireless-2026-09-30
    https://git.kernel.org/netdev/net/c/be35a3e00394

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


