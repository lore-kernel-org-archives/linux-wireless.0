Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:41138 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbZKSAVR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 19:21:17 -0500
Received: by iwn8 with SMTP id 8so1339298iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 18 Nov 2009 16:21:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091118230506.GA5889@jm.kir.nu>
References: <43e72e890911171337p4b0d97fcp844266137bb51b56@mail.gmail.com>
	<43e72e890911171345q2dc59d66g6ac2a9eec04c577c@mail.gmail.com>
	<4B031B48.1090105@roinet.com> <43e72e890911171404x1a46d07alb54946768d0f9cf5@mail.gmail.com>
	<4B032390.3080501@roinet.com> <20091117225408.GA20540@jm.kir.nu>
	<43e72e890911171512k562f9329td56cc741dd1c5151@mail.gmail.com>
	<1258581492.10593.24.camel@mj> <43e72e890911181408r43dadf7av277b255eb9007481@mail.gmail.com>
	<20091118230506.GA5889@jm.kir.nu>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 18 Nov 2009 16:21:03 -0800
Message-ID: <43e72e890911181621g4c2c28e1m693e8bc4796e73e1@mail.gmail.com>
Subject: Re: [Madwifi-devel] Survey: What are you using MadWifi for, and why?
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Pavel Roskin <proski@gnu.org>, David Acker <dacker@roinet.com>,
	Andrey Yurovsky <andrey@cozybit.com>,
	Michael Renzmann <mrenzmann@madwifi-project.org>,
	madwifi-devel@lists.sourceforge.net,
	madwifi-users@lists.sourceforge.net,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 18, 2009 at 3:05 PM, Jouni Malinen <j@w1.fi> wrote:
> On Wed, Nov 18, 2009 at 02:08:16PM -0800, Luis R. Rodriguez wrote:
>> Are you aware of any regulatory rules which prohibit narrower
>> channels? It just seems odd.
>
> I don't remember any rules that would explicitly do that, but there may
> be some implicit limitations due to the slower TX rate. I don't know
> whether this would hit anywhere, but at least quarter width channel with
> 1 Mbps TX rate and maximum frame length might get pretty close to some
> maximum TX-without-sensing limits. Though, that is less likely to be an
> issue on 5 GHz band due to 6 Mbps minimum TX rate even at quarter
> channels could be fast enough. There could also be some rules that state
> the minimum TX rate, so there could potentially be need to change
> supported rate sets and/or fragmentation threshold in some corner cases.
>
> Actually, even with 6/4 Mbps TX rate, the channel sensing rule in Japan
> (carrier sense every 4 ms) (if that rule is still valid.. haven't
> really checked), we could hit the limit with maximum frame length.

Thanks for the details, we'll poke our regulatory guys just to confirm.

  Luis
