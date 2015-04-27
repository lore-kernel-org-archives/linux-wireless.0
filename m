Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:34772 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932426AbbD0Lek (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Apr 2015 07:34:40 -0400
Received: by oiko83 with SMTP id o83so86358473oik.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Apr 2015 04:34:40 -0700 (PDT)
Date: Mon, 27 Apr 2015 06:34:37 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Nuno =?utf-8?Q?Gon=C3=A7alves?= <nunojpg@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Ubuntu regulatory database
Message-ID: <20150427113437.GA4268@ubuntu-hedt> (sfid-20150427_133444_475176_6F87F1E2)
References: <CAEXMXLSucPD3x6igB6pLs=8cBmc-oY0Ah+nLA3kVfS1y6kLhLQ@mail.gmail.com>
 <20150425190912.GA1706@ubuntu-xps13>
 <87y4leqhu6.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <87y4leqhu6.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 27, 2015 at 08:08:01AM +0300, Kalle Valo wrote:
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
> channels? Is there any way to make it easier to update the regdb in
> older Ubuntu versions?

It's likely we'll start pulling in updates on a continuing basis for as
long as a release is supported. It's been on the list of things to get
worked out right after 15.04 releases, i.e. this week.
