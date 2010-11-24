Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:42016 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752268Ab0KXO4g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 09:56:36 -0500
Message-ID: <4CED27A0.70001@gmx.net>
Date: Wed, 24 Nov 2010 15:56:32 +0100
From: Wolfgang Breyha <wbreyha@gmx.net>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Linux Client vs. CISCO AP with band select
References: <4CE6EA98.3020300@gmx.net> <20101120112753.GA12225@jm.kir.nu> <201011201304.48821.helmut.schaa@googlemail.com> <4CEBE834.9000303@gmx.net>
In-Reply-To: <4CEBE834.9000303@gmx.net>
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi again;-)

I have proof now, that the APs respond to authentication requests regardless
of a successful probe before. Simply skipping the direct probe is sufficient
to connect successfully.

All my efforts to find a way to get a response to the probe requests were
unsuccessful. Maybe that's something only aironet devices handle correctly?

Greetings,
Wolfgang
-- 
Wolfgang Breyha <wbreyha@gmx.net> | http://www.blafasel.at/
Vienna University Computer Center | Austria

