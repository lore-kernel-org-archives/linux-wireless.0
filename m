Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:38360 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758809Ab0BYCh4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2010 21:37:56 -0500
Date: Wed, 24 Feb 2010 18:37:44 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Subject: Re: 802.11 development process - extended documentation
Message-ID: <20100224183744.52732c77@nehalam>
In-Reply-To: <4B85E1B6.4000705@free.fr>
References: <43e72e891002241618w10d5c45ar9303f074d0228217@mail.gmail.com>
	<4B85C59C.3010602@free.fr>
	<43e72e891002241643o3ba0b0bp5c7b90a6ae6680ec@mail.gmail.com>
	<43e72e891002241705w4a8c7029le4d1118ee7a68bb9@mail.gmail.com>
	<4B85E1B6.4000705@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 25 Feb 2010 03:34:30 +0100
Benoit PAPILLAULT <benoit.papillault@free.fr> wrote:

> Luis R. Rodriguez a écrit :
> > On Wed, Feb 24, 2010 at 4:43 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> >   
> >> On Wed, Feb 24, 2010 at 4:34 PM, Benoit PAPILLAULT
> >> <benoit.papillault@free.fr> wrote:
> >>     
> >>> Luis R. Rodriguez a écrit :
> >>>       
> >>>> I've extended our 802.11 development process into a new section on our
> >>>> 802.11 wiki. I often get asked how this works from different parts of
> >>>> the company here at Atheros so figured it'd be easier to illustrate
> >>>> this as best as possible and share it.
> >>>>
> >>>> http://wireless.kernel.org/en/developers/process
> >>>>
> >>>> Hope it does justice, John if you see any mistakes feel free to edit.
> >>>> If the diagram seems fishy let me know what I can fix.
> >>>>
> >>>>  Luis

The part that is missing is the -stable kernel tree (Greg KH).
As a distro maintainer, I find the stable kernel tree the most important of all!
More important than the compat-wireless tree (sorry Luis).
