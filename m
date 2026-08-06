Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B97C494832;
	Thu,  6 Aug 2026 19:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786046134; cv=none; b=sZflqQQA1qffv0uqPYXAguuFesA2/timFHdsgytCWFV2xNrxPg+aUIWRLy760ktRqpGU2Y9tZeMCadsmjojpaWDWmCg9pvszYb7rmWDV3YtFPZi7Z5QUJWIhx4lvlxRnEYPqc3oUi8X5MnG3yfia4R2ybIbU6mWU4fqwZhAEzJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786046134; c=relaxed/simple;
	bh=9xXFxWBZhtBBjmvdni477OdAS4SuKxy9UV+7qr+hAAc=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=f6EuCtVlOAF6+RhPA7PCnF2s7aQviaLCZ5yeEd3ZjZFRQHrGbgB5gMubW4j4WKYrLtG/wazSAVaga1pXcmzuWGfpIgPRTnCEjJurJ3uAf3Y7sr1n18ZlZaqNDFbzP5eAxTSbhm/F/4yejpRhvJhdkw0WCqcbqBFLJmuLs5EA4YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FFPp/0/+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FFPp/0/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18971F000E9;
	Thu,  6 Aug 2026 19:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786046132;
	bh=WWEZqZQ6JDzY6qsRYwTpGP3OBrrR+iSWUun0CDpR9GE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=FFPp/0/+oUAg7x549IYw+p9c5EP3vshAAshXGS7tctrT3K3bgKtumm1gwLM/AlpwS
	 SZ7wcu7GaNapgFB2s8ftN/Y953wlJPmUAcXwJmz4N5cNP8aNlogGpirA63i6f7XAZd
	 37bUGWOn9YkB7rlntNEWjvKrgIMqxwNPoLpFO/A04dclw5rFw0SQNWgTvYs9pPEtRH
	 s0EmjBAmjJQ3KYdv045Wy2ZsgcAt6ieFwPwiXvZjFUGrDRID5GUYGbZ/zww8InRtEe
	 ykWBmcZCz18g7Al7W9XK10IxYQeLhVQ6lPX7m2FIuSFM3CAeSyPoNAOPtbOTcLagYv
	 8lHKTwQNJMRGg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 1991F3809A29;
	Thu,  6 Aug 2026 19:54:53 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] wireless-next-2026-08-06
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178604609190.1449574.17126966400520817454.git-patchwork-notify@kernel.org>
Date: Thu, 06 Aug 2026 19:54:51 +0000
References: <20260806121304.190084-3-johannes@sipsolutions.net>
In-Reply-To: <20260806121304.190084-3-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  6 Aug 2026 14:12:35 +0200 you wrote:
> Hi,
> 
> Last code for this cycle :-)
> 
> Nothing really to say - beyond the tag it's mostly
> small cleanups and fixes here and there.
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] wireless-next-2026-08-06
    https://git.kernel.org/netdev/net-next/c/4fa4977a0d90

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


