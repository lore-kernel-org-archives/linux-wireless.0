Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="B4CcsHeU"
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:242:246e::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29E010FF
	for <linux-wireless@vger.kernel.org>; Fri,  1 Dec 2023 00:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=5DWagvj1CA8MScOkBkQIcrlMwt66VS+jBzwsb4mHB34=;
	t=1701418639; x=1702628239; b=B4CcsHeU9O5uPUhlj098kjVKeGX5Tr9YdoKzNmQziEsg1a4
	5B2IlM61KZrUdXai2lLbqHcC1ayG/801P9/SzUeUgY1eh6rb6dWLSCAlwdLwojrWeftH2z2DV/NGC
	juBh4gbGg7XQje4/hHwU0cQzqXLJK8AdENz0Usm89xjbj+iBvOInKU41m/ndMsN0ztk8ySiGqABDi
	X0fb0RzAZXaUZ8zBe1+3R40+WMEGH/f1IYHhi3v6jUpcqvKyOFrZr/PizeuXcKp//7qSnmqTEOupo
	a2eMNBLjJ8HpS3i1bfxxC2Z9az6VN5eLeXaQ0n+PAcGLrXbwBepGZb3v7DbxUc8w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.97)
	(envelope-from <johannes@sipsolutions.net>)
	id 1r8yi5-0000000B7B0-217x;
	Fri, 01 Dec 2023 09:17:17 +0100
Message-ID: <12f110339b4daeb5ab920369a2226dc33ab7e058.camel@sipsolutions.net>
Subject: Re: [wireless-regdb] [ANN] wireless-regdb: master-2023-09-01
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <sforshee@kernel.org>
Cc: Chen-Yu Tsai <wens@kernel.org>, wireless-regdb@lists.infradead.org, 
	linux-wireless@vger.kernel.org
Date: Fri, 01 Dec 2023 09:17:15 +0100
In-Reply-To: <ZVqTTC2rqNpKHptJ@ubuntu-x1>
References: <ZPJF1/2YA4dP+ggY@ubuntu-x1>
	 <CAGb2v657baNMPKU3QADijx7hZa=GUcSv2LEDdn6N=QQaFX8r-g@mail.gmail.com>
	 <ZUAUahZakEvOXpip@do-x1extreme>
	 <CAGb2v66cVj2O89G9qhKCqca+jyBK9ic3866giL=LZX4mQo-eDg@mail.gmail.com>
	 <ZVqTTC2rqNpKHptJ@ubuntu-x1>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Sun, 2023-11-19 at 16:59 -0600, Seth Forshee wrote:
> On Tue, Oct 31, 2023 at 05:32:15PM +0800, Chen-Yu Tsai wrote:
> > > Johannes will be the one who needs to accept your key into the kernel=
,
> > > so we should wait for a +1 from him at least before we really get the
> > > ball rolling.
> >=20
> > +Johannes for his opinion.
>=20
> Johannes, we haven't heard from you. Let us know if you have any
> objections, otherwise I'm going to start moving forward on this.
>=20

Sorry! I fell way behind on email :( Yeah I'm happy with this.

johannes
