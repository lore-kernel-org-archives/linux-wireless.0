Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:49538 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913AbZIOQNb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2009 12:13:31 -0400
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Alejandro Riveira =?iso-8859-1?q?Fern=E1ndez?=
	<ariveira@gmail.com>
Subject: Re: [rt2x00] rt2500pci is spamming syslogd since upgrade to 2.6.31
Date: Tue, 15 Sep 2009 18:13:31 +0200
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <20090915174233.7db381cd@varda>
In-Reply-To: <20090915174233.7db381cd@varda>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200909151813.32223.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>  Hi; my syslog has many entries like this since the upgrade to 2.6.31
>  
>  phy0 -> rt2500pci_set_device_state: Error - Device failed to enter state 1 (-16).
> 
>  Sometimes the driver just start spamming like crazy sometimes is at less rate
>  sometimes it does not appear.
>  
>  I'm running 2.6.31 with a revert [1] config follows. If more info is needed
>  just ask 
> 
>  [1] http://bugzilla.kernel.org/show_bug.cgi?id=13362

Try disabling powersaving,

	iwconfig wlan0 power off

Ivo
