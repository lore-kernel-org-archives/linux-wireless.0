Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from exprod7ob111.obsmtp.com ([64.18.2.174]:50734 "HELO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751611AbaH2Lrb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2014 07:47:31 -0400
Received: by mail-wg0-f49.google.com with SMTP id y10so2045024wgg.32
        for <linux-wireless@vger.kernel.org>; Fri, 29 Aug 2014 04:47:29 -0700 (PDT)
Received: from [10.0.1.56] (62-249-228-36.static.enta.net. [62.249.228.36])
        by mx.google.com with ESMTPSA id pm6sm17916837wjb.36.2014.08.29.04.40.00
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 29 Aug 2014 04:40:00 -0700 (PDT)
Message-ID: <5400668F.4010201@polkaspots.com> (sfid-20140829_134734_809457_51BAFB96)
Date: Fri, 29 Aug 2014 12:39:59 +0100
From: "andrew@PolkaSpots.com" <andrew@polkaspots.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: delay probe response
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is there any way to delay probe responses with ath9k.
What basically I'm trying to achieve is probe responses on the 2.4 ghz 
to be answered slower that the one on the 5ghz, thus causing the client 
to associate to the 5ghz if he has that option.

Is this the correct approach? Is my logic off?
