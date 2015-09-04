Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48512 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752955AbbIDM2R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Sep 2015 08:28:17 -0400
Message-ID: <1441369694.1971.3.camel@sipsolutions.net> (sfid-20150904_142820_647680_B5BC7114)
Subject: Re: [PATCH] rfkill: Copy "all" global state to other types
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Jo=E3o?= Paulo Rechi Vita <jprvita@gmail.com>,
	linux-wireless@vger.kernel.org
Cc: Joe Perches <joe@perches.com>,
	=?ISO-8859-1?Q?Jo=E3o?= Paulo Rechi Vita
	<jprvita@endlessm.com>
Date: Fri, 04 Sep 2015 14:28:14 +0200
In-Reply-To: <1440507403-9695-1-git-send-email-jprvita@endlessm.com> (sfid-20150825_145653_434189_A1131C7C)
References: <1440462512.2670.83.camel@perches.com>
	 <1440507403-9695-1-git-send-email-jprvita@endlessm.com>
	 (sfid-20150825_145653_434189_A1131C7C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-08-25 at 08:56 -0400, João Paulo Rechi Vita wrote:
> When switching the state of all RFKill switches of type all we need 
> to
> replicate the RFKILL_TYPE_ALL global state to all the other types 
> global
> state, so it is used to initialize persistent RFKill switches on
> register.
> 
Applied.

johannes
