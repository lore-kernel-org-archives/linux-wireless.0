Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from edge10.ethz.ch ([82.130.75.186]:4043 "EHLO edge10.ethz.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817AbaC1Qvv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 12:51:51 -0400
From: "Sim  Daniel" <simd@student.ethz.ch>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: tx_retries and tx_failures on iwlwifi
Date: Fri, 28 Mar 2014 16:45:39 +0000
Message-ID: <554FD98DB8827B47BDFF0FDF5415A43B035FCF36@MBX13.d.ethz.ch> (sfid-20140328_175200_980489_4CC38858)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear All,

I am working on a project in which I would like to get the Packet Delivery Ratio (packets delivered / packets transmitted) statistic.

I am working on this project on my laptop with iwlwifi installed (Centrino Advanced-N 6200). Using the iw command I can obtain the tx_retries and tx_failed statistics. However, I am puzzled by the output.

According to the documentation,
- tx_failed is the "number of failed transmissions (retries exceeded, no ACK)".
- tx_retries is the "cumulative retry counts".

Since the default number of retries seems to be 7, I would expect tx_retries to be at least 7 times tx_failed. However, on my computer tx_retries is about 20 times **less**  tx_failed. This doesn't make sense to me. Shouldn't the tx_failed counter increment only after a certain number of retries? And therefore be less than tx_retries?

Regards,
Daniel Sim

