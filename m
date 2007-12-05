Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:43181 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbXLEJxF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 04:53:05 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "John H." <mistamaila@gmail.com>
Subject: Re: b43 seemingly broken with Fedora (2.6.23.8-63.fc8) kernel
Date: Wed, 5 Dec 2007 10:51:13 +0100
Cc: "Larry Finger" <larry.finger@lwfinger.net>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
References: <5b9417770712042039v2d7b2cc7l549d0bda2a57888e@mail.gmail.com>
In-Reply-To: <5b9417770712042039v2d7b2cc7l549d0bda2a57888e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200712051051.13667.mb@bu3sch.de> (sfid-20071205_095325_843056_87A61FF2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 05 December 2007 05:39:02 John H. wrote:
> I just upgraded to this kernel but i could never connect to an AP, it
> just went on and on and timed out.  I had to go back to
> 2.6.23.1-49.fc8
> 
> did something big change?
> 
> 

Yes, a big bug was introduced that breaks it on some devices.

-- 
Greetings Michael.
