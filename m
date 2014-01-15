Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:35367 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbaAOQLO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 11:11:14 -0500
Received: by mail-ob0-f182.google.com with SMTP id wn1so1384294obc.27
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jan 2014 08:11:13 -0800 (PST)
Message-ID: <52D6B31F.8080007@lwfinger.net> (sfid-20140115_171117_754078_ED06BDC6)
Date: Wed, 15 Jan 2014 10:11:11 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: andrea.merello@gmail.com,
	Bernhard Schiffner <bernhard@schiffner-limbach.de>
CC: John Linville <linville@tuxdriver.com>,
	Greg Kroah-Hartman <greg@kroah.com>,
	linux-wireless@vger.kernel.org
Subject: Re: RTL8187SE staging Linux driver
References: <CAN8YU5NTKUtS8+YzmcOSM3=YUX-FSwLTD86F_hXsNdVkw5NEGA@mail.gmail.com>	<522F584E.6000806@lwfinger.net>	<CAN8YU5PCFj-gtQwuuR3fM52YAVTi_5NYPbDVj-KMSzMpXjvFWQ@mail.gmail.com> <CAN8YU5PGkx9s9deWpFTO_ZtDr-+wDD5cX2JRv1zd1m1Q0BpkCw@mail.gmail.com>
In-Reply-To: <CAN8YU5PGkx9s9deWpFTO_ZtDr-+wDD5cX2JRv1zd1m1Q0BpkCw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrea,

Just a head's up, but I had a kernel panic overnight. This kernel (3.13-rc7 from 
wireless testing) has been stable - the only thing new is the RTL8187SE. I have 
no diagnostic information other than the blinking console lights. If/when I get 
more info, I'll let you know.

Larry

