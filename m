Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA603C872A;
	Mon, 28 Sep 2026 10:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790592363; cv=none; b=nlrEtSv/5kqtM1RPjJBfhNjcIH6iVdr68aCOm7MjRCtnEUG+foyVO3s3S0wCiUtIxJFwMb9PtTSbXPNU4s/N7ueLly0tOkELj/XadJPhaCPb7ZJIndLaUTEBvHGQO8iC+OfS/h/KXCqLMqSVhqCBpvwykHQrjfeUXQCYQf7Pwqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790592363; c=relaxed/simple;
	bh=4HY1rhShNplVD1uYjLK69J8DC6QrFRuoQVjEfxJjIcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZmRIhnVoop3LV0V3FS812GbLeY5EfD++cW8bspWikDOZjvXD8qv7FI6nw4eudMOWIjWy2GHyscEybx5L8otFsUmcKXRjxNuyFonZApG7pGoLrZmYDpjMVBBII49H/Pp4j77it5/VRNN9Jpepn5yVSK8PmfMFL+5KZpFTOvOtN6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d+ObSL7N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d+ObSL7N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21EFE1F000FF;
	Mon, 28 Sep 2026 10:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790592362;
	bh=CEHWQPy/uASwlHT9tocP9jeHW5JUYL4pbOZUXBAR8Kw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d+ObSL7NmVwgZ5CetVsOmta6+zHX0rXHYEv9nuyxlygav4PytvrpEhAD/OO+vqYmG
	 mA/YvV45H2OE0BO+W+yoki5Ho5pRE2K6NFUExGXqQHS++Um+qpXyPSZZoEeDEjccTP
	 pmTbfs/ZalORJDqABrZeOqv9av/qC5lZUd66rslbejulJ2bNoUJU32nWva75wUOtP3
	 ujSKosQyBYoLqmu0q/9UP73WAkwLa1lLMmtJPmbrKuaYXuGa5FMpI4MTqZ1RYRpc/J
	 tsn9VEzHRis7cuA8U/30b1suyPSEaFB1CoV1THE3VQTvqjCTcdmvaq4TrU9GRtNgAG
	 lX21azifF3VXw==
Date: Mon, 28 Sep 2026 12:45:58 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: George Moussalem <george.moussalem@outlook.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	linux-wireless@vger.kernel.org, devicetree@vger.kernel.org, ath11k@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Vignesh Viswanathan <vignesh.viswanathan@oss.qualcomm.com>, 
	Varadarajan Narayanan <varadarajan.narayanan@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH ath-next 01/16] dt-bindings: net: wireless: ath11k: Sort
 compatible names alphabetically
Message-ID: <20260928-vengeful-masterful-capybara-c605ff@quoll>
References: <20260923-ipq5018-qcn6122-mpd-v1-0-86729521a75c@outlook.com>
 <20260923-ipq5018-qcn6122-mpd-v1-1-86729521a75c@outlook.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260923-ipq5018-qcn6122-mpd-v1-1-86729521a75c@outlook.com>

On Wed, Sep 23, 2026 at 04:05:07PM +0400, George Moussalem wrote:
> Sort the compatible names in the binding file alphabetically for
> legibility and correct ordering.
> 
> Signed-off-by: George Moussalem <george.moussalem@outlook.com>
> ---

This could be fine, but your next patch suggests qcom,ipq5018-wifi
should be moved out of here.

Best regards,
Krzysztof

