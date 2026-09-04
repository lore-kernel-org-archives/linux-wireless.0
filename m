Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D5F449B03;
	Fri,  4 Sep 2026 13:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788528792; cv=none; b=S9CjshPKdRUqrs/YFy98r6BDgMjk+bQ0Mu4IHXpOxnlOfpeNyTVj0gOvBdyt/L6kYT8sbtl2l6udh7+rLrDPFmqVtTKXOs81h1IVCOZiLo1Js5MCPiIREg8NtlTJDneXH2mYuyl7HQI2M+SkFGxcXSRmQM3RIxS6MZFk1omCWJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788528792; c=relaxed/simple;
	bh=CGbVIhnuqQm983MfuX/rvUeKWbaf/AD+0wa+T4GrEiA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nUc8dCiEq7+P3YKsGL+d42VygDcmzTkNnE57NURZDYrdhAauke15jNhaIV5GjKBiAcmO1xgqSruOrOrsSn24nV4rfMxzz1Bm7ZSRdI8Orqjt6bpWGtpVCtj9xkKOiaSb8S7qQeW6qbeg9NCJ1oARE8hsbY6DVjH1EWGWJUfRB+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=T0G9O2nq; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="T0G9O2nq"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 4BFE41FA9F;
	Fri,  4 Sep 2026 15:33:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1788528780;
	bh=z+cqzpNYbfB3q741sWWcY9PdVpzXOAannb73iMuUN0c=; h=From:To:Subject;
	b=T0G9O2nqi8c9b+QvqWalxaMUWA0s4nHibcO1Mu/6q0wQtk/KDGjFO2q9g8e3RAEkb
	 saObcAmi709Y2UXl2Y4Mfrd1iAsmqga24fbBfyhwUnVBJrn3lpL0W1S7ZIJL46aqoC
	 ebTHLJHOyLAFkkDuWeco4RM5cWlZK0rVa4i0kCDyvbOR3yyh9Zo5wRAlGOMweoMF/B
	 HStZW3Xt0PcxVg7djsAQLcj27Rqq+ae7UZTrl4QLG2X19Osxf275V51crEfyT8ORGc
	 n/gDALI24oycA2ohsAlD0GbUAtvsTjKyQwU93kewId1lqubr9TT5FAmUBXJVgEexOb
	 LGpdWQcUoB8Qg==
Date: Fri, 4 Sep 2026 15:32:55 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Hemanth Selam <hemanth.selam@gmail.com>
Cc: Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wifi: mwifiex: fix typos in comments
Message-ID: <20260904133255.GA132149@francesco-nb>
References: <20260904103922.10193-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904103922.10193-1-hemanth.selam@gmail.com>

On Fri, Sep 04, 2026 at 04:09:21PM +0530, Hemanth Selam wrote:
> Fix typos in comments, reported by scripts/checkpatch.pl using the
> misspelling list in scripts/spelling.txt.  Only touches comments, no code
> changes.
> 
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>

From what I know this kind of patches are not welcome in netdev, thanks.

Francesco


