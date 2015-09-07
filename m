Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:64170 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbbIGJrY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2015 05:47:24 -0400
Message-ID: <55ED5D28.8000309@broadcom.com> (sfid-20150907_114727_883458_63EE9237)
Date: Mon, 7 Sep 2015 11:47:20 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes.berg@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: using dev_coredumpv
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

I am looking at devcoredump subsystem and I was wondering about the 
lifetime of the devcd folder. With dev_coredumpm() the description says: 
"If a previous one hasn't been read yet, the new coredump is 
discarded.". I am wondering what "read" means here. For testing I call 
dev_coredumpv() every second, but when I hexdump the data file it does 
not create a new devcd folder. That only occurs after 5 minutes. Is that 
expected?

Regards,
Arend
