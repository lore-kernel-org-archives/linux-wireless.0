Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D603C0639;
	Fri, 22 May 2026 11:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779449412; cv=none; b=NbJrDJ3gozyp9wXQh4dn+ZCsRq8c8m6rF1PX1j+WgZ4KN0Buwh8pLnetiJcCk78YtghM8Bo2Lvftel+uaQJ/kOVN+4ldnQhN5yXZv83xuJW0xhFbGGE4wc8c0G/1Ype3SbhtkYrDfASiVwGnqRyRLHOO2XcZg/wcd3YwqlY1Aws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779449412; c=relaxed/simple;
	bh=mda+FlaZ6DN6Odl6d40znwaRTMUQ3PjixsGobu2aY+U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=fSPk67Zq7NdVZlf1nas16f6rvI3qieiTLgFAB+1eIgNRKnN3j0ErBXCkW/tniSa7hcyqw3M+t6up4lEGBma/+EomzE3CgAD1OioAET/QFYxvRuXyhvlT18dA+KqymkZeYJs2jnrbEsuSPcOGgtRRcurGoSFANRNC5FgDRS4JmmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Authentication-Results: mail.toke.dk; dkim=none
To: Rosen Penev <rosenp@gmail.com>, linux-wireless@vger.kernel.org
Cc: open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH ath-next] wifi: ath9k: call external_reset on AR91xx
In-Reply-To: <20260521232331.261761-1-rosenp@gmail.com>
References: <20260521232331.261761-1-rosenp@gmail.com>
Date: Fri, 22 May 2026 13:30:07 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <8733zjptq8.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Rosen Penev <rosenp@gmail.com> writes:

> Fixes some stability issues there.
>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Rosen Penev <rosenp@gmail.com>

Same comment for this one - how did you test? :)

-Toke
