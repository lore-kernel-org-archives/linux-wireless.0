Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8982 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab2FKWYi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 18:24:38 -0400
Date: Mon, 11 Jun 2012 15:24:35 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: "Luis R. Rodriguez" <mcgrof@frijolero.org>,
	Johannes Berg <johannes@sipsolutions.net>, <froh@novell.com>,
	<mailman-owner@linuxfoundation.org>,
	Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozancag@gmail.com>,
	<mcgrof@kernel.org>, <linux-wireless@vger.kernel.org>,
	<lf_driver_backport@lists.linux-foundation.org>,
	<linux-bluetooth@vger.kernel.org>
Subject: Re: [Lf_driver_backport] [PATCH] compat: backport ether_addr_equal
Message-ID: <20120611222435.GN21439@tux> (sfid-20120612_002443_317714_CB7FDCEA)
References: <1337162148-16499-1-git-send-email-ozancag@gmail.com>
 <CAB=NE6W2dz=Ld=w5+7jexKk9xfADhk644mc4C=TtbvBZ9_cKGg@mail.gmail.com>
 <4FB40FF0.4050809@hauke-m.de>
 <1337201182.18519.15.camel@jlt3.sipsolutions.net>
 <CAB=NE6Xg_Vn8GQD6PFXoE+17hV51Ge-z=OwM1kQODH1dWYzScg@mail.gmail.com>
 <4FD66865.7000901@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FD66865.7000901@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 11, 2012 at 11:51:33PM +0200, Hauke Mehrtens wrote:
> On 06/11/2012 08:49 PM, Luis R. Rodriguez wrote:
> > On Wed, May 16, 2012 at 1:46 PM, Johannes Berg
> > <johannes@sipsolutions.net> wrote:
> >> On Wed, 2012-05-16 at 22:37 +0200, Hauke Mehrtens wrote:
> >>
> >>>> Content-Type: text/plain; charset="utf-8"
> >>>> Content-Transfer-Encoding: base64
> >>>>
> >>>> And then all I see is this when I save the e-mail to a txt file, given
> >>>> that the encoding is base64. This is odd given that I see you sent
> >>>> this with X-Mailer: git-send-email 1.7.10.1 -- so not sure how this
> >>>> ended up going out like this.
> >>>
> >>> That's strange, when I save this mail I got over the mailing list with
> >>> Thunderbird it is not based64 encoded and when looking into the source
> >>> code with my mail program it is normal text mail.
> >>>
> >>> From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
> >>> Subject: [PATCH] compat: backport ether_addr_equal
> >>> Content-Type: text/plain; charset=UTF-8
> >>> Content-Transfer-Encoding: 8bit
> >>
> >> Well, which list? :-)
> >>
> >> I suspect you looked at linux-wireless, and Luis looked at
> >> lf_driver_backport (given his reply tag), so maybe the
> >> lf_driver_backport list re-encoded the email.
> > 
> > Great, so gmail doesn't even let me "see" the linux-wireless e-mail if
> > it was sent also to lf_driver_backport, I can tell given that I cannot
> > see the bottom of the e-mail a footer indicating this came from
> > linux-wireless. If lf_driver_backport re-encoded it then it seems all
> > patches sent to that list get busted. Bleh. I gotta address this...
> > 
> > froh you seem to be listed as the owner of the list, can you review this?
> > 
> >   Luis
> 
> All the mails I got through lf_driver_backport are base64 encoded and if
> I and the lf_driver_backport mailing list are in CC or TO I just get one
> mail directly and no mail through the list, different to
> wireless-testing mailing list where I would get two mails, one directly
> and one through the list.

Thanks Hauke, in the meantime lets ignore the lf_driver_backport list then...

  Luis
