Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:3559 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757948Ab0EXSdz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 May 2010 14:33:55 -0400
Subject: Re: iwl3945 bug in 2.6.34
From: reinette chatre <reinette.chatre@intel.com>
To: Satish Eerpini <eerpini@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTik_7rxDBc0TKlAfoYyM5S6Cf_Hyxbr4W5ORnTsq@mail.gmail.com>
References: <AANLkTik_7rxDBc0TKlAfoYyM5S6Cf_Hyxbr4W5ORnTsq@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 May 2010 11:33:49 -0700
Message-ID: <1274726029.2091.15160.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Sat, 2010-05-22 at 23:25 -0700, Satish Eerpini wrote:

> No probe response from AP 00:1b:da:2a:a1:53 after 500ms, disconnecting.
> iwl3945 0000:10:00.0: Error sending REPLY_RXON: time out after 500ms.
> iwl3945 0000:10:00.0: Error setting new configuration (-110).
> iwl3945 0000:10:00.0: Error sending REPLY_RXON: time out after 500ms.
> iwl3945 0000:10:00.0: Error setting new configuration (-110).

This did not use to be an issue with 3945 and unfortunately we do not
know what is triggering it now. Please try the "Enable stuck queue
detection on 3945" patch that is attached to
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=1834 as a
workaround.

Reinette


