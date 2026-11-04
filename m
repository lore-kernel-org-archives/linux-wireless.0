Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793801407;
	b=J8Ldm9N1kVAv4jkYPxeovwE2xMSilswresa85F8R3tMIgBf5UFqRw9XrCWlKYgFwhE8n
	 dJ7GamEeTARcCgJsjyaQB7oAgDmHAhxa5vfjCBtg0eXD25ldfqNY5JRRK2OQagBYeQVvA
	 7ksx0ja01pCHXJsnhn0caBT9sJ/NzQymqaq/HWCL9JVtmgFczh6SB9ZgdgXQjsvD2JGwQ
	 q2WZ/sXnf09NkvuxRNIjFRROSM9awaWsVhrtKe+OUWr1KsQI5MJDHLwsSTnOMjOI5v0S1
	 uwWEDeC2CmGu7TM362S7nXAGLngGZrDsp3KGvFs4E2vTeCPe61imy9/ys3UHHszRwvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793801407;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=fW5HOlKTan2dR5Wf4x0NwheYEdGlIy7He4FvyJlAgog=;
	b=4RbvRkcz6HQGw+I83JFY5Y2dh0lTkTNaElVGMlXUgz0flnfheqRG+chGEH2+h11k2lAe
	 ZHcBb2HvsZJsIC1HRC9SngytWaWmXRPo+CW9JdGVeXclMKa6S8xrbYuCfRqLzve5KG4aG
	 3at2C7AyeCBasGiRM788wUao/jT4TsJuKwAaOTPlCJmTOyGyNRBquA0beHNcbAKvxPbgM
	 lQU7Imm973XpS44w9peBoQkql2EpbIxTbJHSURyFMlWqjAwXESQd5WIjvo0/LFFGbBn41
	 0fabyAWXtkZVwONyBs2bS5s7gT3ZDgjUw6DCOIVcXV/S83htLa2QJfZ17/IqKPNdE7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CeWoWOl6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA62606A31B;
	Wed,  4 Nov 2026 14:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CeWoWOl6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858F11F0093A;
	Wed,  4 Nov 2026 14:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793801406;
	bh=fW5HOlKTan2dR5Wf4x0NwheYEdGlIy7He4FvyJlAgog=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=CeWoWOl6ONr6tzoXfmX/Yu8rfwRLb/el9MYes1hTO5dA6NPZpdFRq5Ot38As1HpuA
	 p/e7ddOoUvQISg03VEz5BemkYXkh79um1yx0XlN9ijoeI2NDZFfzAY4FusZ6BymNod
	 xUV38waywxRAOL1OKLrsPlv3QyWuoSxIPTzueG5cfsoiZG2yWahI0XhWWF5P88Yi5y
	 EHGzhR4KoGnrEFidDpNhhDPDp0NAZ8AgbV6PI6W0i+3BuZPu26t2CYWtU0+E6KBdEU
	 E15jg4jUoNwiA93ZbTDVf34zxh6UuABsvK5v24GW0/fnHf6KOh3dMvfzCLfIkdhTNp
	 vdAie2vQohSxw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7D25939E4DA8;
	Wed,  4 Nov 2026 14:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] wireless-2026-11-02
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179380140530.2844943.17914935106232306722.git-patchwork-notify@kernel.org>
Date: Wed, 04 Nov 2026 14:10:05 +0000
References: <20261102104649.727621-3-johannes@sipsolutions.net>
In-Reply-To: <20261102104649.727621-3-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon,  2 Nov 2026 11:46:33 +0100 you wrote:
> Hi,
> 
> Just a handful of fixes I'd collected before, sending
> them so I can get the latest versions once all the
> merging happens.
> 
> Please pull and let us know if there's any problem.
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] wireless-2026-11-02
    https://git.kernel.org/netdev/net/c/c4328134f3f7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


