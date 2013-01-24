Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from telegweb.telechips.com ([219.240.43.111]:58267 "EHLO
	sfilter.telechips.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab3AXMCW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 07:02:22 -0500
Received: from [219.240.43.118] ([219.240.43.118])
          by sfilter.telechips.com ([219.240.43.111])
          with ESMTP id 1359027279.885808.3001945008.sfilter
          for <linux-wireless@vger.kernel.org>;
          Thu, 24 Jan 2013 20:34:39 +0900 (KST)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ks_c_5601-1987"
Subject: [question] how can i make to 32bit aligned address for the 'data' field of sk_buff structure ?
Date: Thu, 24 Jan 2013 20:58:25 +0900
Message-ID: <F4F751F96C54D346898D4C77E196E3DB0A3F6C6D@telegweb.telechips.com> (sfid-20130124_130225_739320_7392B263)
From: =?ks_c_5601-1987?B?seK787/4IChTVyBLaSk=?= <oprsystem@telechips.com>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hello everyone.

i have question. i want to use DMA for the 'data' field of sk_buff structure.
but sometimes, the 'data' field of sk_buff structure is not 32bit aligned.
so, how can i make to 32bit aligned address for the 'data' field of sk_buff structure ?

best regards.
sangwon,ki


