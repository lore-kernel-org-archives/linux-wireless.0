Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFA636DA1A;
	Wed,  7 Oct 2026 23:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791416416; cv=none; b=ac4gf7ly56pZ7lOCdGx7lklIFqd/pK7IZRi4B8uwZ9Diegqs+1ksKjixbgrptNgjqwHpd5UD890LRrLeiyefWGdVC0Ur5TPLM4gt+VXEzR73v2T5gFst5HmWKtUqsg8KmD4rFm98r9gmGnbUfX3gvMfpNOyfXmA7+33PJMPs1yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791416416; c=relaxed/simple;
	bh=dWSbO468FuWIiyhKaZwNrHXxsdEcLvqXn5/ITf4qyAc=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=WL1NIVr30Wot4OJAykMXUMPhv96vWA/YpQJ2wHfcjnl4lgPmg9lhbGK3DD6fLUHsE2xovTZbuyXo+L5nqV2HJVnRDdlWFV4iX7BiUhrFTgd5DCLaxLYjiLRC1wK5XNhd41/WoWE5jPjU0VJdwj4ye0Nqja1rF6lJLi0YbAHFvPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h0hU8whL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h0hU8whL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF731F00893;
	Wed,  7 Oct 2026 23:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791416414;
	bh=WCFUunJhajHLbi209lz2m0sglzfhl/boAYIS4QhWoGE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=h0hU8whLwpnmUiewm85a6xpzrcWEH3bWVSOjrp1Xixo9KldRsXXb19q6ttf1wHIri
	 8kZl40XbdIxEwxKcKQmouOGFj+tKcXv2DPXbwTykl+CJFeO8ArXQdpoHAk2n9y/tDm
	 YLG9wB2dBEQ7aJ/iPSPl7nqwKMS8gW+2uRsv0uViZ1NFK5EDOhkAUDRBlH4EQUi3Og
	 vAoIzIDrNKkZ331M/Mk81tPTeyh2pVA0kwSsN3kYIt9oVAwZBIHh+8pOfsR+ZX/80T
	 tGapqRw6fMRCcpaMLgcfwZpA8G90YUYI1rtklhOe1yf1UAvWcBkUBhai73vprWxhLB
	 SdFwTUvnSbRXw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 773FA3809A08;
	Wed,  7 Oct 2026 23:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] wireless-next-2026-10-07
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179141641303.3735789.18222247089813775078.git-patchwork-notify@kernel.org>
Date: Wed, 07 Oct 2026 23:40:13 +0000
References: <20261007205827.467974-3-johannes@sipsolutions.net>
In-Reply-To: <20261007205827.467974-3-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  7 Oct 2026 22:57:00 +0200 you wrote:
> Hi,
> 
> Nothing much going on in wireless-next. However, next time
> I hope to land my RTNL-redux series which will (almost)
> completely wean the wireless stack off the RTNL, except in
> places where we need it for netdev register/unregister/etc.
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] wireless-next-2026-10-07
    https://git.kernel.org/netdev/net-next/c/991a02c88199

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


