Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48265 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab1GSGNa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 02:13:30 -0400
Message-ID: <4E252076.1050309@gmail.com> (sfid-20110719_081357_629073_77E75E13)
Date: Mon, 18 Jul 2011 23:13:10 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
MIME-Version: 1.0
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	linux-wireless@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: ath: Unable to reset channel (2412 MHz), reset status -5
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

seems with the latest Mainline I am getting the ath9k carpping out after 
a while of streaming(dmesg below)..:
http://fpaste.org/D7wM/

will try a bisect if I have the time..

Justin P. Mattock
