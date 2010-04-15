Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60155 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756095Ab0DOTfm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 15:35:42 -0400
Received: by pva18 with SMTP id 18so1176518pva.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Apr 2010 12:35:42 -0700 (PDT)
Message-ID: <4BC76A8A.1020402@lwfinger.net>
Date: Thu, 15 Apr 2010 14:35:38 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl818x: Move configuration details to the rtl818x 	directory
References: <4bc7623b.jCI2ikmsWKrNCgoa%Larry.Finger@lwfinger.net> <s2t3ace41891004151219kb118330fh8fa4b3830e0c9fbe@mail.gmail.com>
In-Reply-To: <s2t3ace41891004151219kb118330fh8fa4b3830e0c9fbe@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/15/2010 02:19 PM, Hin-Tak Leung wrote:
> On Thu, Apr 15, 2010 at 8:00 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> In preparation for new rtl818x devices, move the existing rtl818x configuration
>> into the rtl818x directory.
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> 
> Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>
> 
> are we going to have a lot more rtl818x devices?

There will be at least one. The mac80211 driver for the RTL8187SE is
receiving data and it can transmit short packets (48 bytes or less).
When I transmit a packet of 68 bytes, the device returns a TX interrupt
for that one, and then seems to freeze. So far, I have not found that
problem, but I expect to find the problem fairly soon.

If anyone has any clues for this problem, I would be most interested.

Larry

