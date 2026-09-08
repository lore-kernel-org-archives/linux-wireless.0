Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296C8214A9B
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 08:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788857168; cv=none; b=ni4aZlyWyyXoq9eATqoSQWNinpdQzIcs4ul8UjaVHd8cduvLhxSxwdzh8ljE6skIOYXLaGNpoqltQOzojqZdhikIQvIVy4QNQVaND5Onxl8plyDNHr1ST63MidCRoxljpLS3LP7mCEa+QWb/OSyQvvcxH/WPi4npUUKwt3xKVoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788857168; c=relaxed/simple;
	bh=Erdlx8G8i3XZ456XDndg3mTfzBWZyGlyr5LNhLlO3ls=;
	h=Message-ID:Subject:From:To:Date:Content-Type:MIME-Version; b=flvMf8S4V0txyI9MAfnOlu1IAyrlo/GoruRuLqM0EqeipWcLx3Fim4S2lH23PI+U4I7zE7oxWr+Qotf3IanuveSk2fk17bOOfNQ9xtngTcfumAb7V5YyyYZI53823baXjbvmNbizDVOskl3P+1TmC9bzVOZx9DjvAJ5kaWWpn/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=q71pPWyx; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="q71pPWyx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:Date:To:From:Subject:Message-ID:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=Erdlx8G8i3XZ456XDndg3mTfzBWZyGlyr5LNhLlO3ls=; t=1788857165; x=1790066765; 
	b=q71pPWyxGCgI0du6fAys4//pgeEoucvK3gclfnYUcmHrklFTctaOZdmQuh5wO74DH03IRAgTNDN
	tO6GH7gCXtW3cM0nJJ6gzoDRzPUFZRTlByVzjK5ABGSsRTCMzp1yp+XBE39zZn49QYCvqHtqZBgHv
	1aMpm6NZ1ZIoi19VQxWqQiIdFqntZXDpXVFFu0b3LWG1JLSZi943ylnwd32y/hKypRbGfOpr/nFIc
	r0m5kT3r6Ox1ywmtfVZPtX5xVtOMc2IqLFv1692XuJn2XmeDnsVkXVVsEvITN+HQJy6bluic5LuuM
	7c27IpnY3RW/PTHjG/Bo/ibopft+LhRd9U0Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x3rSq-00000005tHx-3joc
	for linux-wireless@vger.kernel.org;
	Tue, 08 Sep 2026 10:46:01 +0200
Message-ID: <fe0d8a3c2951c051b321902582eaf95f230a754d.camel@sipsolutions.net>
Subject: patchwork update / NIPA issues - please resend
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Tue, 08 Sep 2026 10:45:59 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

Hi,

Due to a patchwork update which botched NIPA runs, I've dropped a fair
number of patches from my queue that didn't get NIPA runs. If your patch
has 1 or 2 results from NIPA shown in patchwork instead of ~25 please
resend.

johannes
