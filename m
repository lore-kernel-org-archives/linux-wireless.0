Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756159Ab2COLCd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 07:02:33 -0400
Date: Thu, 15 Mar 2012 12:02:20 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Tom Gundersen <teg@jklm.no>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	linux-wireless@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: MAINTAINER NEEDED -- Re: status of ipw2x00
Message-ID: <20120315110219.GA2335@redhat.com> (sfid-20120315_120236_738002_18B91FAD)
References: <CAG-2HqUqwHo_xgqC79riQF2DA4DPz1Qy5ZARQK8GT+tf_-UKRg@mail.gmail.com>
 <20120130184446.GB2493@tuxdriver.com>
 <CA++WF2PnEzS5CAfryaPrJSs3Xb3s0WK1zR7N5o8+ud2HiU5GCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CA++WF2PnEzS5CAfryaPrJSs3Xb3s0WK1zR7N5o8+ud2HiU5GCw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 03, 2012 at 11:58:03PM +0300, Stanislav Yakovlev wrote:
> Hi John,
> 
> On 30 January 2012 21:44, John W. Linville <linville@tuxdriver.com> wrote:
> > On Mon, Jan 30, 2012 at 02:42:52PM +0100, Tom Gundersen wrote:
> >
> >> If we are not able to drop the 2x00 drivers, are anyone still
> >> interested in working on them to fix the firmware loading?
> >
> > Anyone out there looking for a project?  A way to "break-in" to the
> > public Linux community without the risk of breaking anything too
> > important? :-)
> >
> > If someone wants to be the ipw2x00 maintainer, all they need to do
> > is start sending some non-broken patches...
> 
> I would volunteer taking ipw2x00 driver maintenance if it is ok with everyone.

Hi Stanislav

Perhaps you should post a patch that change ipw2x00 entry on MAINTAINERS
file.

Are you plan to fix issues caused on current firmware loading changes on
linux ? We have a few bug reports about that:

https://bugzilla.redhat.com/show_bug.cgi?id=783708
https://bugzilla.redhat.com/show_bug.cgi?id=802106

Stanislaw
