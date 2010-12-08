Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f180.google.com ([209.85.161.180]:48858 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab0LHPPP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 10:15:15 -0500
Received: by gxk19 with SMTP id 19so893767gxk.11
        for <linux-wireless@vger.kernel.org>; Wed, 08 Dec 2010 07:15:14 -0800 (PST)
Message-ID: <4CFFA112.7030800@lwfinger.net>
Date: Wed, 08 Dec 2010 09:15:30 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: b43-dev <b43-dev@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: b43 N PHY status report
References: <1291755360-21570-1-git-send-email-zajec5@gmail.com> <AANLkTikp9ErFopLZVmXMjN3tXF2L62SwEEcujKeOBLYC@mail.gmail.com>
In-Reply-To: <AANLkTikp9ErFopLZVmXMjN3tXF2L62SwEEcujKeOBLYC@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał,

The N PHY driver is remarkably stable. So far, my link has been up for nearly 16
hours under normal conditions - I have not yet tried any stress tests. Other
than the PHY errors that you noted, my link has only reported 2 other unusual
events. I have had 3 "Deauthentication for reason 3" from which it recovered in
one try. Also logged are 9 instances of "RX: Packet size underrun (2)/Packet
dropped" events. Again, these caused no problems.

Larry



