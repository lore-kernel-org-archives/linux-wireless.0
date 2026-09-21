Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3533B4B0CA3;
	Mon, 21 Sep 2026 18:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790014474; cv=none; b=BKokELgx4mz2BE/joRzc8/MnOG7kXScr8Fih3+bK5o5WIq0acUzCvmJTRm+CbGoV3iEAB73+KphbAvGmC2HBAyNhR2loRygSF7Vs79acDOHXz2QrQgvR+JWLe/OlwUZ2Wyq60Y2rai4wInxvfKjp/8FWG+/1Zyxti/rS4GWUCwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790014474; c=relaxed/simple;
	bh=6YuQJa6tRcL04IbnY4OrY4FKCrUXCyID6MdDlT39I8I=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Qs5ruUfzUJaNR/KES4K5afaRA5HelOaPHEieIKH+Vw1sRreXsN31QXNM/krivJkXjylrTEaLbg8KA7yAnLycTjJijEtuX6+JUaoecX11Qyek89s8l5aUBDOSkwy7NJkSL8MJ4spzv6h7H4UvD6sGggneHlGxotW2cCxraeuH2KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=CIRooko5; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="CIRooko5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=6YuQJa6tRcL04IbnY4OrY4FKCrUXCyID6MdDlT39I8I=;
	t=1790014473; x=1791224073; b=CIRooko5f8NZwBcy44wxlwzAU4aygQlbcm5fPcOfuct522G
	2vthN8ssO/5wVweUkuBjBe5AGp7ISKI5YaPPHKiFI0IP+VuCPOH9Hlq+6Qh30nTiZ4ix1BrFj/nfS
	kXzYB2jPhVa+b46ISB6PPPXiAixUPKNU+N0vIG2TOhUaYkU7/BRcFoREIK7tNUQmSIio+/xG0R/gv
	wjeJRhxGzl5X+iAKRs6m6URQTbJFcxIizOs9CJG1hZ/gPXH1IptLu2lZUz6CGXMd3Y2FhDoFrD0iG
	GJtkcAnsVjduG9pmjekIdlVxYOr606UdjKgBnHRw2IGmG1bp8PxzK6MKc7LaemXA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x8iX8-00000005zgD-08wY;
	Mon, 21 Sep 2026 20:14:30 +0200
Message-ID: <c208152fc5cb45e19ae7d4660394dbf2bc5e0271.camel@sipsolutions.net>
Subject: Re: [PATCH v3 6/6] MAINTAINERS: add entry for the RTL8723B rtw88
 driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Luka Gejak <luka.gejak@linux.dev>, Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, Michael
 Straube <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
 Bitterblue Smith	 <rtl8821cerfe2@gmail.com>
Date: Mon, 21 Sep 2026 20:14:29 +0200
In-Reply-To: <31285267ebc43aab631a4199059a247a8d937814@linux.dev>
References: <20260921154347.82317-1-luka.gejak@linux.dev>
	 <20260921154347.82317-7-luka.gejak@linux.dev>
	 <45eb7d5908f8fff9a18cba603fd3a4abfe8695f9.camel@sipsolutions.net>
	 <31285267ebc43aab631a4199059a247a8d937814@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Mon, 2026-09-21 at 16:49 +0000, Luka Gejak wrote:
>=20
> It is supposed to work in the same way it works for other driver
> maintainers. I would review patches and provide my acked by or
> reviewed by them and Ping-Ke would apply them to his rtw-next branch.

I don't think we have a lot of folks below the driver maintainers who s
end me pull requests (except Toke maybe?) - but as long as I don't need
to deal with it I'm happy, you can figure it out between yourselves :)

johannes
