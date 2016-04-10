Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19523 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932355AbcDJTRs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2016 15:17:48 -0400
From: qca_merez <qca_merez@qca.qualcomm.com>
To: Joe Perches <joe@perches.com>,
	qca_merez <qca_merez@qca.qualcomm.com>,
	Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	wil6210 <wil6210@qca.qualcomm.com>
Subject: RE: [PATCH 4/7] wil6210: print debug message when transmitting while
 disconnected
Date: Sun, 10 Apr 2016 19:17:42 +0000
Message-ID: <22bd7713a48b46e2bb2f1ec67ad6c409@euamsexm01a.eu.qualcomm.com> (sfid-20160410_211759_084121_AA40AC3D)
References: <1459855447-17413-1-git-send-email-qca_merez@qca.qualcomm.com>
	 <1459855447-17413-5-git-send-email-qca_merez@qca.qualcomm.com>
 <1459927376.6715.37.camel@perches.com>
In-Reply-To: <1459927376.6715.37.camel@perches.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 4/6/2016 10:22 AM, Joe Perches wrote:
> On Tue, 2016-04-05 at 14:24 +0300, Maya Erez w
>> +void __wil_dbg_ratelimited(struct wil6210_priv *wil, const char *fmt, 
>> +...) {
>> +	if (net_ratelimit()) {

> Inverting the test would reduce indentation.

I preferred to have the same implementation as in wil_err_ratelimited.
