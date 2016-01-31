Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757479AbcAaOcB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 09:32:01 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joe Perches <joe@perches.com>,
	Alexander Kuleshov <kuleshovmail@gmail.com>,
	Haneen Mohammed <hamohammed.sa@gmail.com>,
	Andreas Ruprecht <andreas.ruprecht@fau.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"devel\@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: rtl8723au: Fixes unnecessary return warning
References: <20160129172908.GA14077@Karyakshetra>
	<wrfjk2ms465z.fsf@redhat.com>
	<CAGRGNgWQvdfQc-L9z0NKCyCOorxU0seQ-XvYnZDBWA3QKySrRA@mail.gmail.com>
Date: Sun, 31 Jan 2016 09:31:58 -0500
In-Reply-To: <CAGRGNgWQvdfQc-L9z0NKCyCOorxU0seQ-XvYnZDBWA3QKySrRA@mail.gmail.com>
	(Julian Calaby's message of "Sat, 30 Jan 2016 10:17:00 +1100")
Message-ID: <wrfjfuxd2529.fsf@redhat.com> (sfid-20160131_153309_852026_7211534B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julian Calaby <julian.calaby@gmail.com> writes:
> Hi Bhaktipriya,
>
> On Sat, Jan 30, 2016 at 5:00 AM, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
>> Bhaktipriya Shridhar <bhaktipriya96@gmail.com> writes:
>> If you insist on pushing this rather unncessary change, please do it
>> properly, and remove the blank line before the return statement as well.
>
> As Jes said, you need to remove the blank lines before the returns
> too. checkpatch should have picked this up, you did run the patch
> through checkpatch before you sent it, right?
>
> Jes,
>
> I know you have strong feelings on coding style, but there are a lot
> of people out there who see deviations from the standard as bugs to be
> fixed, so stuff like this isn't going to stop until it matches the
> coding style document's spec.

Julian,

rtl8723au is pretty dead development wise, so I don't care too much.
checkpatch is broken and has effectively turned into a policing tool for
a few people who wish to apply their narrow view onto everyone else.
I'll continue top reject broken patches to my code pushed out under
those rules.

Maybe it's time to introduce checkpatchconsideredharmful.com

Jes
