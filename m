Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:35459 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751468AbbD0FWJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Apr 2015 01:22:09 -0400
Message-ID: <1430112118.12579.2.camel@coelho.fi> (sfid-20150427_072213_630892_4B136610)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Seth Forshee <seth.forshee@canonical.com>,
	Nuno =?ISO-8859-1?Q?Gon=E7alves?= <nunojpg@gmail.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 27 Apr 2015 08:21:58 +0300
In-Reply-To: <87y4leqhu6.fsf@kamboji.qca.qualcomm.com>
References: <CAEXMXLSucPD3x6igB6pLs=8cBmc-oY0Ah+nLA3kVfS1y6kLhLQ@mail.gmail.com>
	 <20150425190912.GA1706@ubuntu-xps13>
	 <87y4leqhu6.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: Ubuntu regulatory database
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-04-27 at 08:08 +0300, Kalle Valo wrote:
> Seth Forshee <seth.forshee@canonical.com> writes:
> 
> > On Sat, Apr 25, 2015 at 06:26:34PM +0100, Nuno Gonçalves wrote:
> >> I was surprised that the wireless regdb provided with Ubuntu 15.04 is
> >> almost 2 years old.
> >> 
> >> Are you aware of the reason Ubuntu is not providing a updated regdb by default?
> >
> > This doesn't really seem on topic for the mailing list as it's a distro
> > issue.
> >
> > But yes, it recently came to my attention that our distro package hadn't
> > been updated in a while (I don't maintain the distro package and
> > obviously wasn't paying close enough attention). It will be updated
> > soon.
> 
> Oh, so does this mean that the old regdb doesn't support 80 MHz
> channels?

Yeah, we had a bug reported from the community that turned out to be
about this:

https://bugzilla.kernel.org/show_bug.cgi?id=95901


--
Luca.

