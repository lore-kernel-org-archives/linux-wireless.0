Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:33937 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030967AbbEEUUt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2015 16:20:49 -0400
Received: by wgso17 with SMTP id o17so196306008wgs.1
        for <linux-wireless@vger.kernel.org>; Tue, 05 May 2015 13:20:48 -0700 (PDT)
Message-ID: <1430857244.4122.11.camel@gmail.com> (sfid-20150505_222102_107420_FCC9A2AE)
Subject: rtlwifi: dhcp fails after physical reconnect, suspend/resume
From: Maxime Poncet <maxime.poncet@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>
Date: Tue, 05 May 2015 22:20:44 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi !

This issue was fixed by commit
 cad737dfde3566e3293e884e8b391e2cae7e8068 ("rtlwifi: Add encryption
argument in rtl_is_special_data for checking DHCP packet.").

Could you make this patch available in stable kernels ?

Thanks.
