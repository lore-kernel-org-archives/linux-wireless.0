Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost04.isp.att.net ([204.127.217.104]:33675 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbZDOEe3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 00:34:29 -0400
Message-ID: <49E563C2.8030502@lwfinger.net> (sfid-20090415_063435_121499_E315DB09)
Date: Tue, 14 Apr 2009 23:34:10 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@Opfer-Online.de>,
	Matthew Garrett <mjg@redhat.com>
Subject: Re: [RFC v6] rfkill: rewrite
References: <1238349195.24972.5.camel@johannes.local>	 (sfid-20090329_195345_745378_2F2074B3)  <1239745712.4205.17.camel@johannes.local>	 (sfid-20090414_234944_810890_D7EBA134) <1239750483.4205.28.camel@johannes.local>
In-Reply-To: <1239750483.4205.28.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> This patch completely rewrites the rfkill core to address
> the following deficiencies:

> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> v3: * fix locking bugs
>     * fix bug in input.c that made it ignore things
>     * allow setting LED trigger name
>     * apply default state while registering
>     * convert HSO
> v4: * LED triggering
> v5: * convert sony
>     * introduce rfkill_set_states function
>     * change query/poll methods to require calls to
>       rfkill_set{_sw,_hw}_state/rfkill_set_states
>     * do not call driver from registration
>     * remove tested-by since it changed a lot
> v6: * fix stupid sync work bugs

V6 works with b43legacy.

Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
