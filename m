Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C6E38F93D
	for <linux-wireless@vger.kernel.org>; Wed,  4 Feb 2026 08:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770192801; cv=none; b=Q3y64o/11pSKSKLGJoe/GtI41pcyCotxigQmH66IXeTR1Qj2sLNQxjvaGGLVzAJ2KoKoxnSoU0DdtU2HOjqBDhU3pw0PF4wQi58yex1bpKZqf4fZhTHOzgdzVwPor5vLQDZyt7hz1ffXW+tmkNrU4tRa0bw7aTj9nE7APmKRj/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770192801; c=relaxed/simple;
	bh=IZOarF8CokO3Ex+jOx9HTEBKwfpWKUVfKkWgNHPto8w=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=SefgQM4Kb2bNF8ovQfx8NNVktDZnWTZ1JSEvSBVfy0czTUZzykyo/5Ng0Pf8BUGFj6jd50pKwtvOmVhe9sA5LwjKC01B8dXLekWATr3EKu88H6Zoi0uTn5/qbKEq0lWO8KmNk2mCe0m+BcvxidkieASQGrUkL2orPVPa8pjcasc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KXqLtwZP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KXqLtwZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169EBC4CEF7;
	Wed,  4 Feb 2026 08:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770192801;
	bh=IZOarF8CokO3Ex+jOx9HTEBKwfpWKUVfKkWgNHPto8w=;
	h=Date:From:To:Subject:From;
	b=KXqLtwZPHx4aUw11ygDi2OjFAa3PdOVE85t2JB4FwXPr5MXRUneT3m9qVusYX0gzb
	 Sg1ewX9g6QT2nZN4+BviI9SyZGVCJsc4cjDwfFOQ5ztWx1PZ+36Rbt0BhWF7dLGAk4
	 /2Op6/yIwvmieenK8nzJTknyDgG6AxUKQFJ7hhTVpQ54fEYwwQFky7saB/I+edaU1K
	 nDo28QITLiCC95T0mQXzIF24YfAyyCdBt+W/lfLulSnUL5Jw6cpJ9UgEEvQgkjEeg3
	 x3OFH8SEbkvC2eg1LvopT7zXrCKkCy3AUdmPcIqp5rhcvyj869CxPDiSkS14W7NY4M
	 pmO/lPO1kPVQw==
Received: by wens.tw (Postfix, from userid 1000)
	id E36155FD85; Wed, 04 Feb 2026 16:13:18 +0800 (CST)
Date: Wed, 4 Feb 2026 16:13:18 +0800
From: Chen-Yu Tsai <wens@kernel.org>
To: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [ANN] wireless-regdb: master-2026-02-04
Message-ID: <aYL_nqHUidmUCDOe@wens.tw>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

A new release of wireless-regdb (master-2026-02-04) is available at:

https://www.kernel.org/pub/software/network/wireless-regdb/wireless-regdb-2026.02.04.tar.xz

The short log of changes since the master-2025-10-07 release is below.

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
