Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793095216;
	b=TVVDLNlMXg/oRphNeEn9h3g/ODCxavBYRgXrzvAbsAr5Vwj3vo72EQVWW6uj5lsGV8Es
	 O2lY1fLVEVitkx3OhcInw6Xse1Ug2TTuxJN1jLKcTingyZlXrpUVPehZ6TyPyeiBVlYD2
	 IQNH7vW0BSyBBBin9d4R/K3vtFcpFYomPAOZJH6fDzs/nmx3zR5ZwvLrm6ZG+xxWZW0FG
	 CmhrFfPckbGERVK3jL5Kyi6Dp+XVMam8NPHTkXPJsYxq9gyUn2zM7W5fFTt/XsZQd49BS
	 GeiDWdeBM5G580EP/3LsS2iLWX1fYLdDynoef7lLnTZkZNBfqzxz1n7EEZSo3HKz7RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793095216;
	h=Received:DKIM-Signature:Received:From:To:Cc:In-Reply-To:References:
	 Subject:Message-Id:Date:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Mailer;
	bh=1l4k9+Kt62tGtjW1zLlNxrOSLYSV+PreaSFmwiC/Pqc=;
	b=2TXx0WWzQR3RuUZT4QdG7Af5/pwQo3d7FsEdDj3EqXoEVrWYyfiW+ziezW4U1KKpOKcV
	 vhTUYs/V6dQknfkSRaSCf31rc8w/W2gRhRN36GmSovOPICoFMgYTU4KSksjEwSylb4wyJ
	 h4oyoLlSFLyKGKD7rFXLVuLaZr0IwnMSINaRWkbQaAFHAM9+huiUachssxI56a89QV4bw
	 3+eIXeuzDgsRqcq2oQt9H4xR8nf2EXRLErXWtkxI7RL1fU+HjxXV4TQs2Qt5vEmwzUQuz
	 zFgviL/rcy3WMVW/Nv62zEOu86osKkQbUvgV6Ao/KDHgNRd+1+MG4uyB7elfFFFZetw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="mB/sKI+C";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B858606A321
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 10:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mB/sKI+C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2ADA1F031E3;
	Tue, 27 Oct 2026 10:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793095215;
	bh=1l4k9+Kt62tGtjW1zLlNxrOSLYSV+PreaSFmwiC/Pqc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=mB/sKI+CNyt+O5eJ195w65aWdXKDxl0GbrPdV8oATr3JmrDizwrCa+r6AHx8Od9yq
	 gW8+R3+LxWgVXM/9QFzjV3JzItqiKSHqhjU+aKTqU9Uvsn4i4fEeSro8ALbDQ14Dtz
	 ChtEAM7AHXaojCIFD7PpHcBWCqcNjGNZ0Xgd4gKOUM3zWhrTYiu4DgpLdf5zwNq5ix
	 oFojIuvUq7NhTwOqOw7es6CZ4PGAd7ttQCHYVE14zfZn3IdVaJ1h3hEf4XoRGerNXl
	 tsi0iAXlWB3MEIrcoHGDp+rMdNb0u00xTa/6BvywoaKX6r7IXXaONsY1xRJZKGNKb3
	 nIYzt5twxl+gg==
Received: from wens.tw (localhost [127.0.0.1])
	by wens.tw (Postfix) with ESMTP id 212235FCD7;
	Tue, 27 Oct 2026 18:00:13 +0800 (CST)
From: Chen-Yu Tsai <wens@kernel.org>
To: wireless-regdb@lists.infradead.org, 
 Mohammed Abdullah Ali Al-Obaidi <mnew_iraq@yahoo.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20261025125400.799-1-mnew_iraq@yahoo.com>
References: <20261025125400.799-1-mnew_iraq@yahoo.com>
Subject: Re: [PATCH v3] wireless-regdb: add regulatory rules for Iraq (IQ)
Message-Id: <179309521311.1724500.1361909024866117572.b4-ty@b4>
Date: Tue, 27 Oct 2026 18:00:13 +0800
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Sun, 25 Oct 2026 15:54:00 +0300, Mohammed Abdullah Ali Al-Obaidi wrote:
> Add a regulatory entry for Iraq (ISO 3166-1 alpha-2: IQ).
> 
> Iraq is currently absent from the database, so devices set to
> country=IQ fall back to the world domain (00). The Iraqi
> Communications and Media Commission (CMC) has published a numerical
> national regulation covering Wi-Fi.
> 
> [...]

Applied to master in wens/wireless-regdb.git, thanks!

[1/1] wireless-regdb: add regulatory rules for Iraq (IQ)
      https://git.kernel.org/wens/wireless-regdb/c/40095bd16e53

Best regards,
-- 
Chen-Yu Tsai <wens@kernel.org>

