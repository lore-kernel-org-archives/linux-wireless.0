Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:60549 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560Ab0FDPxB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jun 2010 11:53:01 -0400
Message-ID: <4C092155.5040206@openwrt.org>
Date: Fri, 04 Jun 2010 17:52:53 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Roberto Riggio <roberto.riggio@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Strange ACK Behaviour with ath9k
References: <4BEC2318.5050701@create-net.org>	<AANLkTimnzAJd9Y02m8OBVLHphL5pbFw56M2LfB1L5oKz@mail.gmail.com>	<4BEE684F.2070707@create-net.org>	<loom.20100604T153747-904@post.gmane.org>	<4C09151C.7040509@openwrt.org> <AANLkTik03jIq7xEzdY0FF3LQHI_Zqeu_unbI3CJbUqu-@mail.gmail.com>
In-Reply-To: <AANLkTik03jIq7xEzdY0FF3LQHI_Zqeu_unbI3CJbUqu-@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-06-04 5:02 PM, Roberto Riggio wrote:
> On Fri, Jun 4, 2010 at 5:00 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>> Are you using 2.4 or 5 GHz?
> 
> 5 GHz
Did you test a recent version of wireless-testing/compat-wireless?
IIRC versions before the AR9300 merge had some bugs/inconsistencies in
the fast clock handling for 5 GHz.

- Felix
