Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:38096 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751322AbdKQIQv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Nov 2017 03:16:51 -0500
Received: by mail-wm0-f43.google.com with SMTP id z3so4706052wme.3
        for <linux-wireless@vger.kernel.org>; Fri, 17 Nov 2017 00:16:51 -0800 (PST)
Received: from skynet-x2.localdomain (catv-176-63-144-158.catv.broadband.hu. [176.63.144.158])
        by smtp.gmail.com with ESMTPSA id d3sm2067819edd.41.2017.11.17.00.16.48
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Nov 2017 00:16:48 -0800 (PST)
To: linux-wireless@vger.kernel.org
From: =?UTF-8?Q?R=c3=a1kosi_Gergely?= <rakosi.gergely@gmail.com>
Subject: rtl8723be on Fedora27
Message-ID: <f5876284-360c-e6bf-01c8-ed95c4298647@gmail.com> (sfid-20171117_091659_452104_9D316516)
Date: Fri, 17 Nov 2017 09:16:47 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm trying to use rtl8723be wifi on Fedora27 but I still get continuosly
disconnection. The error in the dmesg is "Init MAC failed"
I tried with the following module options too : "fwlps=0 swlps=0" and
the variant of "ant_sel=1 or 2 or 0"
I downloaded the git files from your repo, and do the usual make,make
install, and modprobe stuffs, and then restart the notebook, but I get
the same result.

Thanks your help,
Regards,
Gergely
