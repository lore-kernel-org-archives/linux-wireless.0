Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C241DD9AC;
	Wed, 16 Sep 2026 00:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789517481; cv=none; b=uQwi45RjHn9rqiZSm6WOvZSdTPSf3q5HYQj2NgkqmBw36WA+10djgr2j94ZfChO9f+2vIM9hxgCaIFq4kJyL5NnKgsmVSaUaF9hKrxAJgYus9OMhCSPNclAE7kSOj1+r+nX66uzThxd/z8cF0XNxxVYKrg6X6YcYrjXym+EB9ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789517481; c=relaxed/simple;
	bh=tNk2lk/ETcxk9WOm8a4avYaurOmQpC0gZa4z41y8j50=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=PBTtsFt1htRgXBKyZtr7FCushBSqmsjheq/nu97HI3ojA4yp6dhnMfgLcgvXRw778XK1AKrbuZtHFN56TR+UNXjGapMEEBX/bO3GCbpVFHzJbEZzWjwF3nXJkUE/ke5xiXySvYaCcx6TU1oxJY8xrqNK+XknfwYougBoA/ukVOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ybu/t1Q5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ybu/t1Q5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF13C1F000FF;
	Wed, 16 Sep 2026 00:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789517480;
	bh=h0jvqgC79bdg0pdzTtOyCEQHgcIpzw+yLTKCSTLmEGk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=Ybu/t1Q5PHjEuRAqiE1/J148VOgeQo8iYgqqmzI/3iXvFuos5aSOQOLpHXOliNZRG
	 V9Ceo1ZveZADvGVvuNzgK5B1vAG3A8BKupH2AYbFtcjypMJxLkxlUqlkwf6iViIytd
	 GhpJmSiPUMs/MIlh7tEKA0PA/atih+k/ElG0HkfPddeCqXsw+r5zrbAVoHvYCcQfa/
	 R6hmDwp/R+8U8lMOJU+RNqgFudRZYhGogexXbCNTotX/AZ+bQ4OE5EV4HSHEOn/VEE
	 +HCxUaB912DLsy3MjZZFOKUHd6jzEsmNUXZtGlUx9xEUbJ1j9sIUnDmpIBoIiTilzG
	 cMLcWkbhcAlHw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 939E7392706C;
	Wed, 16 Sep 2026 00:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] dt-bindings: net: Use consistent indentation
 in
 the example
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178951741413.2328807.13052906737611774655.git-patchwork-notify@kernel.org>
Date: Wed, 16 Sep 2026 00:10:14 +0000
References: <20260914155645.112508-2-krzysztof.kozlowski@oss.qualcomm.com>
In-Reply-To: <20260914155645.112508-2-krzysztof.kozlowski@oss.qualcomm.com>
To: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Cc: justin.chen@broadcom.com, florian.fainelli@broadcom.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, robh@kernel.org, krzk+dt@kernel.org,
 conor+dt@kernel.org, ulli.kroll@googlemail.com, linusw@kernel.org,
 clement.leger@bootlin.com, olteanv@gmail.com, hkallweit1@gmail.com,
 linux@armlinux.org.uk, hayashi.kunihiko@socionext.com, mhiramat@kernel.org,
 nbd@nbd.name, lorenzo@kernel.org, ryder.lee@mediatek.com,
 shayne.chen@mediatek.com, sean.wang@mediatek.com, johannes@sipsolutions.net,
 matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com,
 jjohnson@kernel.org, richardcochran@gmail.com, geert+renesas@glider.be,
 magnus.damm@gmail.com, vineetha.g.jaya.kumaran@intel.com,
 claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com, elder@kernel.org,
 s-vadapalli@ti.com, rogerq@kernel.org, bcm-kernel-feedback-list@broadcom.com,
 netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-renesas-soc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
 ath10k@lists.infradead.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 14 Sep 2026 17:56:46 +0200 you wrote:
> Correct indentation in the examples to consistent 2- or 4-spaces
> indentation to fix dt-check-style warnings ("example 0
> [indent-consistent] indent mismatch ...").  Preferred is 4-spaces, but
> re-indenting entire example just for that is too much churn.
> 
> In cortina,gemini-ethernet.yaml also drop the wrongly indented mdio bus,
> because it is not necessary for the example.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] dt-bindings: net: Use consistent indentation in the example
    https://git.kernel.org/netdev/net-next/c/032ef43b9dab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


