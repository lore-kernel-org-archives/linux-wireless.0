Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16E530F7FB;
	Mon,  3 Aug 2026 10:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785752917; cv=none; b=i8rtzOkbcsl4ZEQrm1ge+Vz1of+Jt5/ZNQpIdg+tMq7bqhyiAh1r+NoOXKmTRQWZmklrT0zzkRR316pwC2DYlZ2zJIpzYdFzk/JDpCEVG2k4P77kOituEjoMdydSIIVg3PrXLqnlniAUdEljAdA8JIuvp6bvFFm2xrK1FjnBiJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785752917; c=relaxed/simple;
	bh=H/b3vav6V6K/9uGYXzvhnbSsjQ0PsjNApteAEUU51dg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=d3Jm5iiMdeynsNoywiJ8+oU6/iWNUjBZDZVDxwg4nJjt04Rc0Au/Elsd/qIOwrS6JOxIYCGj+qU/oXum2irZhFn/a1k+dIKCQJ6IRFWjp2zK7DXDuqYjLCJKvaQz+M6is/Rqa/SHabLADvCuCqEgoAukZ7lbsXVK/G44AkKRM9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=EHeu0Gtm; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="EHeu0Gtm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=H/b3vav6V6K/9uGYXzvhnbSsjQ0PsjNApteAEUU51dg=;
	t=1785752915; x=1786962515; b=EHeu0Gtm+M9DiQJKzKJRWYl4WKizMEfzow3VdWDafsNDyIZ
	gjAM8Cd+UyFJpmbiXwDMKcC00lJZAwTCDGsLnqXkfFCJk9a5w+9RikmN7xMvzRxlzU/hTmU8k4hsc
	mooBvPEvnIjWzXrqIXZihAru7R/OH2ffsM37QhnG24aLLeyjLlQkHoAYyPU27TxkIt2yJ/W0enzSu
	AwXeN4o2vsBcSm0bU9o3rMmes4x3lIJ1EUoYU78OebBv+rWXHJOy7Tk7SdHUUaIBvQ7MEkXTHeSj4
	6oMfYfVjxsZhpI9n63PzvsC43x5OwPC3hneRPOjzrb0Fw+ZKtkTa5G21exp0uV5Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wqpuK-00000008s3A-2XMq;
	Mon, 03 Aug 2026 12:28:32 +0200
Message-ID: <1fe01c6b7d3a8f94717e076d1f645c92337206e5.camel@sipsolutions.net>
Subject: Re: [PATCH] brcmfmac: Add support for BCM4361 PCIe chipset
From: Johannes Berg <johannes@sipsolutions.net>
To: markuss.broks@gmail.com, Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev, 
	brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org
Date: Mon, 03 Aug 2026 12:28:31 +0200
In-Reply-To: <20260803-broadcom-staging-v1-1-f6f77e55b72e@gmail.com>
References: <20260803-broadcom-staging-v1-1-f6f77e55b72e@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

Missing "wifi:" prefix and tree (wireless-next) tag.

johannes
