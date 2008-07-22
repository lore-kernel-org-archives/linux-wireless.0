Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 81-66-111-23.rev.numericable.fr ([81.66.111.23]:55681 "EHLO
	rubis.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbYGVSVa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 14:21:30 -0400
Message-ID: <4886235F.6010407@jourdois.fr> (sfid-20080722_202135_006962_5DDAD2A1)
Date: Tue, 22 Jul 2008 20:13:51 +0200
From: =?UTF-8?B?U3TDqXBoYW5lIEpvdXJkb2lz?= <stephane@jourdois.fr>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-kernel@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
Subject: Re: [ipw3945-devel] [PATCH] iwlwifi: Enable packet injection for
 iwl4965
References: <69e28c910807181205m6dd0cdcek83f9717bf1ac9dcc@mail.gmail.com> <69e28c910807220454q7c8371e1m11b1015ed8398758@mail.gmail.com> <4885DDC4.2060609@googlemail.com>
In-Reply-To: <4885DDC4.2060609@googlemail.com>
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Engel a =C3=A9crit :
> Stefanik G=C3=A1bor wrote:
>> What is the status of this patch? Did it get lost? Was it rejected? =
I
>> didn't get any answer on it, and I can't see it in iwlwifi-2.6.git o=
r
>> wireless-testing.git.
>=20
> Actually it is at least in linux-next since 30th of June as of commit=
=20
> 914233d68f07d5d9c22630cd5a84fdfd98f39da2.

I beg your pardon, but this commit is for iwl3945, not iwl4965.
The patch for iwl4965 is currently not in any git tree.

Stephane.

--=20
  ///  Stephane Jourdois     /"\  ASCII RIBBON CAMPAIGN \\\
(((    Consultant securite  \ /    AGAINST HTML MAIL    )))
  \\\   157 Bd Davout         X                         ///
   \\\  75020  Paris         / \    +33 6 8643 3085    ///
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
