Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EFA366076;
	Thu,  5 Mar 2026 08:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772697938; cv=none; b=XWFRlJTnIL0ucbebM6e21qf2qb80pY7VvACrZxkcTlRSqxPy4Ar0Fqv5H7eYvQIExOq7KMmjRF7Ge25FF68zK6YdYONQ4s5jDHaMKCEpvVwRTKduOx6HbM94CeEa3q7k6Lxx4K63gJYSGUU/C3XFMeHSKyZBUnxfs2tEPpOcprY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772697938; c=relaxed/simple;
	bh=Fha6NDzVdtw4aSWx+iGX0QxEwkWvK34N5hI3c2DVAQE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U6GfocPvZot4E37yJcJjPcFh+BE38zPO1qMah4UK4bk6ldimhX0opXwFKbDJQFN42NcmBXBzPC5mfT0DnDsAr5IGKX2rTlwGNEGtIEnfeZScQFV1Ef3Oxzy4JXux8HBtMcmTbS32qd6hmeqmH4LOj28uHnNOaYXmv40dQjhxF18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K88EOzF/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K88EOzF/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EEA7C116C6;
	Thu,  5 Mar 2026 08:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772697937;
	bh=Fha6NDzVdtw4aSWx+iGX0QxEwkWvK34N5hI3c2DVAQE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K88EOzF/NFdypnS33aUxiBNbPycQZTCWvxfAST7u+iuyc+rRG86rVpr8jGlMcb485
	 5U/ZXEjQSxXVQSrpHWojaPNB+Ldjy3yGpsvSZLT7TvB5copaEijr/6NgAxaWRHazOe
	 Vm/gPwmNjHNw5ymfhrlD7UeIt11YYwcTijdfgWYsxAksIALwiyHwHl0S5RH2mOEUgH
	 gsRy6JlgdzQ+94bFg8o4EcTLzWWvHqYL26p9tChTQo8J/SuXBw1U01zTH0XVIW18R/
	 /0jU9GSWUXduRRVdhRnJuhGongZvmiMcZyAtzyPR9hjMfOSCmOSPbhT2OlL0ksHUdz
	 jOUSHnuP3EpHQ==
Date: Thu, 5 Mar 2026 09:05:35 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Kerigan Creighton <kerigancreighton@gmail.com>
Cc: linux-wireless@vger.kernel.org, loic.poulain@oss.qualcomm.com, 
	wcn36xx@lists.infradead.org, andersson@kernel.org, mathieu.poirier@linaro.org, 
	linux-remoteproc@vger.kernel.org, linux-arm-msm@vger.kernel.org, robh@kernel.org, 
	krzk+dt@kernel.org, conor+dt@kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] dt-bindings: remoteproc: qcom,wcnss-pil: add
 WCN3610 compatible
Message-ID: <20260305-inventive-apricot-badger-7c60ee@quoll>
References: <20260305003253.1022386-1-kerigancreighton@gmail.com>
 <20260305003253.1022386-2-kerigancreighton@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260305003253.1022386-2-kerigancreighton@gmail.com>

On Wed, Mar 04, 2026 at 06:32:51PM -0600, Kerigan Creighton wrote:
> Document the qcom,wcn3610 compatible string for use with
> the qcom_wcnss_iris remoteproc driver.

No, do not document for drivers. Please explain here the hardware.

Also, one patchset per 24h.

Best regards,
Krzysztof

