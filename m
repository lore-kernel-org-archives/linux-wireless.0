Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:50860 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaJZJKp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Oct 2014 05:10:45 -0400
Received: by mail-pd0-f171.google.com with SMTP id r10so3859739pdi.30
        for <linux-wireless@vger.kernel.org>; Sun, 26 Oct 2014 02:10:44 -0700 (PDT)
Date: Sun, 26 Oct 2014 18:10:39 +0900
From: Okhwan Lee <ohlee@mwnl.snu.ac.kr>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"=?utf-8?Q?ath10k=40lists.infradead.org?="
	<ath10k@lists.infradead.org>
Message-ID: <etPan.544cba8f.6b8b4567.764@Mac-Pro.local> (sfid-20141026_101049_418186_AD6F3D9C)
In-Reply-To: <CA+BoTQkxX1fhQVGx7jUkoG6NRz+EP+ZWJwAvNwqHDNv5Fw4COA@mail.gmail.com>
References: <CANzpp-=opT==PUf5FhWi_cbB91+RhWk+jB7M4bfUCqh2wzQA2A@mail.gmail.com>
 <CA+BoTQmHGtO+XCRg1_jJstm+wHRQLU9sEpBRJ7U+_xO3nq7_VA@mail.gmail.com>
 <CANzpp-kV8LzPgeXHq=DHKsLSdTT+-9gjj08RXST4r3-QOtkanw@mail.gmail.com>
 <CA+BoTQn0iEYEQJ4AdO7xfRSHjX1CfO_uovPaxbtxSWQw0vPS+Q@mail.gmail.com>
 <etPan.544a384b.74b0dc51.8406@Mac-Pro.local>
 <CA+BoTQkxX1fhQVGx7jUkoG6NRz+EP+ZWJwAvNwqHDNv5Fw4COA@mail.gmail.com>
Subject: Re: Change channel bandwidth without iw command
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 Hi, 

Thanks for your help.

We just disable some functions step by step. 
Then we can conclude that wait_for_completion_timeout makes kernel panic. 
We guess that monitor vdev stopping after reception of a Action frame requires more time than the case when using iw command. 
Instead of wait_for_completion_timeout, we also use alternative function, wait_for_completion (uses maximum timeout value), 
but the panic is still there.

We don’t have the expert on kernel memory debugging from now on. 
We have to study more how to handle it. 

Again, thank you.
 
Okhwan Lee
Sent with Airmail  

켜짐 2014년 10월 24일 에서 오후 8:38:44, Michal Kazior (michal.kazior@tieto.com(mailto:michal.kazior@tieto.com)) 작성됨:

>  


