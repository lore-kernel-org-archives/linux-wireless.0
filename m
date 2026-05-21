Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A5A3EDE6E;
	Thu, 21 May 2026 18:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779388669; cv=none; b=OjL3CSYLrRhqB0U+GaEHGVnHs4vjlSDgfrgOoSZkoSNwoI4nUv2ecV94eAfpT3YdYCPy36llnCBIC0fcQgiof28ZSabOpWZUiu54GJV0sUz1x9mgV7F4Bw3zE//fPJdHw0cwbLzuBBWcgZCKuGPHi2WhjgOdYulnZ+mBTqdp/JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779388669; c=relaxed/simple;
	bh=0ClkvxM4x3MQeNOIUYUZ/jMbrTckrMTz9DJWDRyOwpA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TtwKTzheLViSc3nVrcmEc8m7jEWKW83whnp8W6DQPGxP2pathZgTLgkS3FYOZ6f4lMysjfQKIukMPjZDksBEv/ER44TjXM/zFlNCzV9YbOLBW4sHWuyIFLOuZLR/kE9+nu+7Hdb5S8uCR3YXKx0lVAOjGAd6uu4IxCaaT9GBmzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UfrUhbbx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UfrUhbbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0891F000E9;
	Thu, 21 May 2026 18:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779388662;
	bh=KC73cyOZxHeKTGOk7mEzMH4GojjtO7mZze7jWHTVIis=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=UfrUhbbxtYvCiMsD/B59EIc3E7ZAox9d1py5cODFyBu/MvBEQ2D63hTAlIlOGj99/
	 abvrEho6ctQzYqUvUnZJAp1eUsUypsORdxCFQiHovBB78cVnob73Wr9FV0lfoMbX93
	 7YNjzJrR1eUj5UGjFq0FA5HS1E36KS1lzKvXOPgDECvRdOU9wV0KcX5RyK/eTNJ/CE
	 uu8e1gOtQ4VQ39U/RxTKGID/XG3ZI5igsE2+5tQ+Xj/PMjkFoXKLszh2k4dj00tcm0
	 TaJOKTB2xJFktIpVu0w6TiUBZCcJxXmfeQTGX5fu5yt8M7focMuno3zpU/phfSkm/v
	 wPsf/Wx+E6tjQ==
Date: Thu, 21 May 2026 11:37:41 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [GIT PULL] wireless-2026-05-21
Message-ID: <20260521113741.19ba6318@kernel.org>
In-Reply-To: <20260521152903.374070-3-johannes@sipsolutions.net>
References: <20260521152903.374070-3-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 21 May 2026 17:28:37 +0200 Johannes Berg wrote:
> Sorry for the last minute thing ... if it makes it at all.
> I forgot during the day, and it's already more because we
> had a holiday last week.
> 
> Please pull and let us know if there's any problem.

I'm also late today. I'm almost tempted to pretend I was waiting 
for you ;)
