Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:30029 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853Ab1F2NfC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 09:35:02 -0400
Message-ID: <4E0B2A03.8010702@gnu.org> (sfid-20110629_153505_573775_715AE714)
Date: Wed, 29 Jun 2011 09:34:59 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Fr=E9d=E9ric_Lamorce?= <FLamorce@CalAmp.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: IPv6 "compatibility"
References: <1309272221-25787-1-git-send-email-mshajakhan@atheros.com> <8BFC9A1FBD4CFA4FA7496C9F6DBCF4CA0DC1B153ED@oxn-mx01.PD.CalAmpCorp.com>
In-Reply-To: <8BFC9A1FBD4CFA4FA7496C9F6DBCF4CA0DC1B153ED@oxn-mx01.PD.CalAmpCorp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/29/2011 09:08 AM, Frédéric Lamorce wrote:
> Just to be sure, all the drivers/utilities (compat-wireless, iw, wpa_supplicant, hostpad, etc) are all completely independent from IPv6, right?

hostapd does need IPv4 or IPv6 to talk to the RADIUS server.  I suggest 
that you check the sources before posting questions.

-- 
Regards,
Pavel Roskin
