Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E48038B98D
	for <linux-wireless@vger.kernel.org>; Wed,  4 Feb 2026 08:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770192008; cv=none; b=Vjit0NRtLXXqC0o7WeGR1KfWOjWuOmRssUq6NwMCtZvYHYzJ0Z/8Mbe7i56zw1sCwWlA+rrf0qKn0jPFOoep9cENLPPuApAW4aG6vjPJMMoMM9RLeHchrKg77wOH4kHzkyBF0dCXlVbA+ix7zHthtKaGif9g+/3meCRc1VAWCl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770192008; c=relaxed/simple;
	bh=vTiQTdd9vDrV9zXzcEUrf2+RxihH/o9Y2WUHdTQeDIU=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=l6IkoMxdCgUGD8S32Pck21GPvNDlqGNjnWYx5KAbV7at4LGD2+2pCeS0ba3qb143lw83sHJLmv/I7nReUi1Yp5mzG+o88B5Jgh/n8NXTBJL7XqjRJCkVLwFAKuRU0aqpIGiWv6o3XNTHl/ZlXN/Mtqr1DRpGOSnV3fK1SWySSgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OKjcJ3qT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OKjcJ3qT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC64C19422;
	Wed,  4 Feb 2026 08:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770192007;
	bh=vTiQTdd9vDrV9zXzcEUrf2+RxihH/o9Y2WUHdTQeDIU=;
	h=Date:From:To:Subject:From;
	b=OKjcJ3qT9mOy9FlicxRUZ5yfGUU5cpYk4lfFXHCmy/qSBxJoTnOJvett7ZpRESYFc
	 ibkPXiCbklu1yFDtdlzMzx/IkSxGXJEEXzpr42/72PbTb0J+kE8UXjIIQI/z8Qt9vX
	 wRo/8uVmyVskNGPbWnrgD1gKjsS5RcrFIVfEyJqVsOYGMKrFbJiCrcmEHUpqXiK1j3
	 vfGT1BV9b7WafMSgy1FQOznSvYbpiRH8Hc9bU/iXdznI2AVrJGtvvQz1nhPnaRZCis
	 eFW82tFTy/cNkP7r1jOfJamqget4jmtxAhUUOw73QEaKQw1PjFLgIwoZGaLEf1lHlr
	 xR0J+u/rNTJfQ==
Received: by wens.tw (Postfix, from userid 1000)
	id 70E885FD85; Wed, 04 Feb 2026 16:00:05 +0800 (CST)
Date: Wed, 4 Feb 2026 16:00:05 +0800
From: Chen-Yu Tsai <wens@kernel.org>
To: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [ANN] wireless-regdb: master-2026-02-04
Message-ID: <aYL8hbqyYUSaF9vn@wens.tw>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

A new release of wireless-regdb (master-2025-10-07) is available at:

https://www.kernel.org/pub/software/network/wireless-regdb/wireless-regdb-2025.10.07.tar.xz

The short log of changes since the master-2025-07-10 release is below.

--

Andrew Yong (3):
      wireless-regdb: Update broken link in regulatory.bin(5) manpage
      wireless-regdb: Update regulatory info for Malaysia (MY) for 2024
      wireless-regdb: Update regulatory info for Malaysia (MY) for 2025

Chen-Yu Tsai (2):
      wireless-regdb: Update regulatory info for Canada (CA) for 2025
      wireless-regdb: update regulatory database based on preceding changes

Ping-Ke Shih (1):
      wireless-regdb: Update regulatory info for Tunisia (TN) on 6GHz for 2025

Richard Huynh (1):
      wireless-regdb: Update regulatory info for Australia (AU) for 2025
