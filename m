Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363764A35;
	Tue, 22 Sep 2026 01:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790040093; cv=none; b=Lh69Kji9q16sVKTroPqk4fN1hCIvPW3dL+cr17PfvtuPYmS24ym+brjXrQjYxuww9D02WwMaqs2lx1M/im5rfkGAgC4SSPAryN7n019EWlnKz0Db0rN380XOntFUjsuGxaz2dsQVKPF6BxuBUW01PT//HLbitjXPEdUFDocLeR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790040093; c=relaxed/simple;
	bh=y1s9kcCqjLfB9+dlwMi1lhX4bMdpAzwuC/f05W7Op44=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=A+on31TPj0g+2Fab4h7Piy9Ockmos1NYJ36Tb79lCTvBtPyZdN139sXk+2mpsXOhKDFS5e7PLVZEx5v+h+x41DpWVnhIbzjOoUqKHW251pTQYIu8T4K81voQgneLWVGjjqALzhPl33H/yYz97Sda2ax64JYgG5ghIxEjepiso18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hic+q2IV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hic+q2IV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044011F000FF;
	Tue, 22 Sep 2026 01:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790040092;
	bh=+mipkHLljePwavV4VIUIaUqH2gSc5v1N4kZTfh7SwL8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=Hic+q2IVZsPliMocUUiMIfsWi6Yg2UNIOuVvoYLFL1CT+DITRB5s+latKRROke2Er
	 6kb2cqEhcoozNF5MCEQ3L/CT2WknkZLHVfxWoPASiJQtyoab2QYi21JXdf4Mt0D3Uv
	 wmnbzOLBKPNB9fIstrk7h8qGKNKYasCYu3sPxBcOeQY+cDFN/C/OkudajYTIDKP5F/
	 2P9AyOd+CIAftVcUfPcValFm8TzfAXwlGMMAKlpqzmtjDws+q5B2YQGL63XX+TSlBv
	 6JBWg/auhSoLJEAc2BsJFrL2/HpPGhjV9+hyBIdcOqtdLz2FUMNojls3jFPSFBfKjf
	 NNsSii27pBjow==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 939CC3930205;
	Tue, 22 Sep 2026 01:20:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] wireless-next-2026-09-21
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179004002314.3321385.8021134198835794287.git-patchwork-notify@kernel.org>
Date: Tue, 22 Sep 2026 01:20:23 +0000
References: <20260921121635.195723-3-johannes@sipsolutions.net>
In-Reply-To: <20260921121635.195723-3-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 21 Sep 2026 14:13:46 +0200 you wrote:
> Hi,
> 
> Some more changes - mostly not very interesting I guess.
> I haven't received most driver updates yet.
> 
> Note there are some merge conflicts - most are reasonably
> easy but the bigger net/mac80211/tx.c one is a bit annoying,
> but it's "take the wireless-next version". I've pushed an
> example resolution to the 'merge-2026-09-21' branch in my
> (wireless-next) tree.
> (I had fixed an issue in wireless, but also did some bigger
> refactoring/cleanup in wireless-next that fixed the same
> issue as well, just differently.)
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] wireless-next-2026-09-21
    https://git.kernel.org/netdev/net-next/c/10cfa109c880

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


