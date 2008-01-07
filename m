Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.187]:34077 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbYAGUUD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2008 15:20:03 -0500
Received: by rv-out-0910.google.com with SMTP id k20so7203081rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jan 2008 12:20:02 -0800 (PST)
Message-ID: <43e72e890801071220r33401a6cg30a0bf4fc391b452@mail.gmail.com> (sfid-20080107_202012_222121_167B0082)
Date: Mon, 7 Jan 2008 15:20:02 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Forest Bond" <forest@alittletooquiet.net>
Subject: Re: VT6656 driver source available from VIA
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080107184949.GI18550@storm.local.network>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20070919193743.GA14127@storm.local.network>
	 <20071101185900.GD14943@tuxdriver.com>
	 <20071101190711.GB17825@storm.local.network>
	 <20071101191250.GE14943@tuxdriver.com>
	 <20071105020730.GA4414@storm.local.network>
	 <20071114170051.GD23778@storm.local.network>
	 <20071114170634.GC6226@tuxdriver.com>
	 <20080107184949.GI18550@storm.local.network>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 7, 2008 1:49 PM, Forest Bond <forest@alittletooquiet.net> wrote:
> Hi,
>
> On Wed, Nov 14, 2007 at 12:06:34PM -0500, John W. Linville wrote:
> > On Wed, Nov 14, 2007 at 12:00:51PM -0500, Forest Bond wrote:
> >> On Sun, Nov 04, 2007 at 09:07:31PM -0500, Forest Bond wrote:
> >>> The post is here:
> >>>
> >>> http://forums.viaarena.com/messageview.aspx?catid=28&threadid=78745
> >>>
> >>> Any noise that can be contributed is welcome and appreciated.  You'll need
> >>> to create an account to post, though.
> >
> >> I also added these.  Perhaps having plenty of content/links regarding this
> >> issue will help to increase visibility:
> >>
> >> http://www.alittletooquiet.net/text/a-license-for-the-via-vt6656-linux-driver/
> >> https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.22/+bug/162671
> >
> > Excellent...I appreciate your efforts as an agitator! :-)
>
> At this point I am not anticipating positive results WRT this endeavor, and am
> unable to pursue further assistance from VIA.  Further, I've seen that the
> driver in question likely exhibits some interesting quirks that makes it
> difficult to use.  It is also bit-rotting out of relevance.

This is unfortunate to hear...

> Can the driver be used as a reference for a fresh implementation?  I've not
> written a driver before, but would be open to the possibility.

IANAL but I believe It basically depends on the license the vendor
issued the driver under and its sources under. If no license was used
then I believe the standard copyright license terms should be assumed.
What license was used throughout the driver files?

> What are the legal ramifications of a driver author having access to
> proprietary source code?

Again, I believe it depends on the license/NDA/terms under which the
driver author obtained access to such proprietary source code. The
more details you provide the better.

  Luis
