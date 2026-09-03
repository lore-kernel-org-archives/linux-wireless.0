Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EC138F928
	for <linux-wireless@vger.kernel.org>; Thu,  3 Sep 2026 05:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788415115; cv=none; b=iSVAMT56BtFf30SzWjPhCdLeFLsBEc7ItbQNAM/nxs03+Gnx8Gdtk2waljkvq8Xsb0Cpa94rCo1KaYlgcjLAExmXr9WENtbrloqxM9O9dTXLZG35Wy3r4YwPgPNjkLkDAZS3NQVLLB2wCcvgF05kJLTzN4mcH04Q71+c6XE495E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788415115; c=relaxed/simple;
	bh=S/eO2cEjaobSlI4uDjN6qVkWLxB7bU3BdnfgKn3dVFg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=qh31Kcr+C/fglFKlZPjKf0Q70LYi4sHTRA6Etg+SFW6h3COjmDnhMeo7EXjbk3Ilm+T1Nq4QSJnEQxlBdjYDpo+D+sn18DAKb5wm/6Y2K5d62++suABx6UX6Dwe8nv4jMy4Ic7W5W6SDmx8DKTsOhYn4stzNjl4VI7mfMueLT2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RjXTXLzu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RjXTXLzu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E221F000E9;
	Thu,  3 Sep 2026 05:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788415114;
	bh=aDBBAL2MZcGVl2XD60tB+Vdp/TfUNi9pIGjmbjA2sOM=;
	h=Date:From:To:Subject;
	b=RjXTXLzunujsO1R4Q89KAXzdKQhKFK79bC6VYimhJPHBXhIV8HPv1yEY9hkYSEINx
	 3eOfxuFZiD1Yv5nKqbJWKHwyBPAuCYhQGSVXKBn/l1kGGVHdXklx/ymTX2DqHg25w9
	 s+oTPve5wmRLzbLM1cm/oRpVcAEwfj4AhuDu6JObh8oxr1F5x9+05RObfeDloHPPnH
	 YnybnsHpxKwvLvPMNB1dPb6bob/U16vaQTxRAMOQWvVLRZaMTlEuLp8rREGkYiv5Xj
	 CMSBkAeFFYZyjnpPcxLNrv8DS+HjBKedgCcrAQdUQLaB7Ad/ZYxe3QsmpSgZVAeyb2
	 lQDXYjmumZOHg==
Received: by wens.tw (Postfix, from userid 1000)
	id 6CF215FDE6; Thu, 03 Sep 2026 13:58:31 +0800 (CST)
Date: Thu, 3 Sep 2026 13:58:31 +0800
From: Chen-Yu Tsai <wens@kernel.org>
To: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [ANN] wireless-regdb: master-2026-09-03
Message-ID: <apkMhwF5T9jiwyCh@wens.tw>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

A new release of wireless-regdb (master-2026-09-03) is available at:

https://www.kernel.org/pub/software/network/wireless-regdb/wireless-regdb-2026.09.03.tar.xz

The short log of changes since the master-2026-05-30 release is below.

--

Chen-Yu Tsai (2):
      wireless-regdb: allow 320MHz channel width for Hong Kong (HK)
      wireless-regdb: update regulatory database based on preceding changes

Louis Kotze (2):
      wireless-regdb: Remove DFS flag from 60 GHz band for Togo (TG)
      wireless-regdb: Update 2.4 and 5 GHz rules for South Africa (ZA)
