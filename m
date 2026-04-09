Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD642BB13;
	Thu,  9 Apr 2026 02:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775700049; cv=none; b=pOsNgiAc74The6GzY/Xgu2DLjSIGfzpzsxYSj3BdmUV/EnBzklnE3V5n34z8b5tHeUBBGZeSChH80zr0IAkM2mNfOvt6zB3CHZ12TOcZmDkEpAOXZWuYGMO5xIrKe5VB0ax6tdNTU43Pn8mjgy703V4owPjmO5xuEny3jhqkmKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775700049; c=relaxed/simple;
	bh=m/wLbFgll4zk5DQnNiOxj6mu9+msbdskQOCLd4toxqc=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=ALx5IwwMIIqat7szEHKFV7UDj3i6IvbhQU5jqtWN+Is1M5cW/sPFPkSCgCzATPNGC0x81sCleE4w5PGfiVHWvI7BFusguv9pPn2nFL6jIY/Um6Sd5rybay1x65hgX7GnotEexkt+SHcGeYQfnyNrXYK4WK2kuQyM/9198IqftDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oof0c96x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oof0c96x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D66C19421;
	Thu,  9 Apr 2026 02:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775700049;
	bh=m/wLbFgll4zk5DQnNiOxj6mu9+msbdskQOCLd4toxqc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Oof0c96xeCherkQGhtESxOAYVOC9hSfqmfwsfta+J5UeUzaSvZcxQOv1gbAeyULcE
	 xTX6NagzUcNS0z2QIzYoP7lgDT162tmUiPh9EzX0nruHiSIDQw+TvEjcNBYKTnXf+h
	 Dvyvd6lTdjRtod7bduwwdlRBcFXD2uPR0aa5NpgKF38nJhuqfP8re+/krjqFg1JlGG
	 9qwJ6JYCbvgPM3Dro9LOfscgZQdY6CYH0R4LFrxzYnppmMKDX40oWtjMWpNj7kFPcZ
	 OC+E7rO7ZYUJUwQzzQYWHB9oFatfEMg3Sl46d40drrw9S/R49Cv/cP1V/qduwtnaCh
	 TaGJ8X81rO2tw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7CD273930793;
	Thu,  9 Apr 2026 02:00:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] wireless-2026-04-08
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177570002504.953143.161114630902259878.git-patchwork-notify@kernel.org>
Date: Thu, 09 Apr 2026 02:00:25 +0000
References: <20260408081802.111623-3-johannes@sipsolutions.net>
In-Reply-To: <20260408081802.111623-3-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Apr 2026 10:15:25 +0200 you wrote:
> Hi,
> 
> So in a way I'd hoped it wouldn't come to this, but while I
> was out last week a couple of things came in that seemed
> relevant enough to squeeze in now. I guess it wouldn't be
> much of an issue if not, but I figured I'd try anyway :)
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] wireless-2026-04-08
    https://git.kernel.org/netdev/net/c/d65b175cfac6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


