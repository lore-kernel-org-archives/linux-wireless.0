Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:62109 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753767AbdBNPGH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 10:06:07 -0500
Received: from localhost ([87.171.2.79]) by mrelayeu.kundenserver.de (mreue102
 [212.227.15.183]) with ESMTPSA (Nemesis) id 0LopTv-1cALWy2wyx-00gnO6 for
 <linux-wireless@vger.kernel.org>; Tue, 14 Feb 2017 16:06:03 +0100
Date: Tue, 14 Feb 2017 16:05:04 +0100
From: Bastian Bittorf <bb@npl.de>
To: linux-wireless@vger.kernel.org
Subject: bad values in output of 'iw event'
Message-ID: <20170214150504.GA10920@medion.lan> (sfid-20170214_160609_638897_7C8E4D86)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

the former patch about rate-report/unfilled values
reminded me, that i can see with recent 'wireless-testing'
strange values when watching the output of 'iw event'.
maybe something similar...:

Mon Feb 13 11:18:52 CET 2017 DEBUG: wlan1-1 (phy #1): unknown event 60
Mon Feb 13 11:18:52 CET 2017 DEBUG: wlan0: del station 64:09:80:7f:48:86
Mon Feb 13 11:18:52 CET 2017 DEBUG: wlan1: del station b0:48:7a:a5:96:2e
Mon Feb 13 11:18:52 CET 2017 DEBUG: wlan1: del station f4:ec:38:fd:74:b4
Mon Feb 13 11:18:52 CET 2017 DEBUG: wlan1: del station f4:ec:38:9d:86:36
Mon Feb 13 11:18:52 CET 2017 DEBUG: ���T (phy #0): unknown event 8
Mon Feb 13 11:18:52 CET 2017 DEBUG: ���T (phy #1): unknown event 8
Mon Feb 13 11:18:52 CET 2017 DEBUG: ���T (phy #1): unknown event 8
Mon Feb 13 11:18:53 CET 2017 DEBUG: wlan0 (phy #0): unknown event 7
Mon Feb 13 11:18:53 CET 2017 DEBUG: wlan0 (phy #0): unknown event 43
Mon Feb 13 11:18:53 CET 2017 DEBUG: wlan0: new station 64:09:80:7f:48:86
Mon Feb 13 11:18:53 CET 2017 DEBUG: wlan1 (phy #1): unknown event 7
Mon Feb 13 11:18:53 CET 2017 DEBUG: wlan1-1 (phy #1): unknown event 7
Mon Feb 13 11:18:53 CET 2017 DEBUG: wlan1 (phy #1): unknown event 43
Mon Feb 13 11:18:53 CET 2017 DEBUG: wlan1: new station f4:ec:38:fd:74:b4
Mon Feb 13 11:18:53 CET 2017 DEBUG: wlan1: new station f4:ec:38:9d:86:36
Mon Feb 13 11:18:53 CET 2017 DEBUG: wlan1: new station b0:48:7a:a5:96:2e
Mon Feb 13 11:18:54 CET 2017 DEBUG: wlan1-1 (phy #1): unknown event 60

thanks & bye, bastian
