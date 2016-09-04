Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:46498 "EHLO
        srv-hp10.netsons.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753718AbcIDUwo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 4 Sep 2016 16:52:44 -0400
Subject: Re: [PATCH v2 1/6] rtl8723au: remove declaration of unimplemented
 functions
To: Kalle Valo <kvalo@codeaurora.org>
References: <1472821069-5437-1-git-send-email-luca@lucaceresoli.net>
 <87a8fq2s3q.fsf@purkki.adurom.net>
Cc: devel@driverdev.osuosl.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
From: Luca Ceresoli <luca@lucaceresoli.net>
Message-ID: <9b2365f1-3d11-05f6-7a28-f6bf458cec42@lucaceresoli.net> (sfid-20160904_225259_962790_D67154EF)
Date: Sun, 4 Sep 2016 22:52:38 +0200
MIME-Version: 1.0
In-Reply-To: <87a8fq2s3q.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Kalle,

thanks for your feedback.

On 02/09/2016 18:18, Kalle Valo wrote:
> Luca Ceresoli <luca@lucaceresoli.net> writes:
> 
>> These functions have been declared without any implementation since
>> the first commit (364e30ebd2dbaccba430c603da03e68746eb932a) and there
>> has been no mention of them in following commits.
>>
>> Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
>> Cc: Larry Finger <Larry.Finger@lwfinger.net>
>> Cc: Jes Sorensen <Jes.Sorensen@redhat.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: linux-wireless@vger.kernel.org
>> Cc: devel@driverdev.osuosl.org
>> Cc: linux-kernel@vger.kernel.org
>>
>> ---
>>
>> Changes v1 -> v2:
>> - improve the commit message.
>> ---
>>  drivers/staging/rtl8723au/include/recv_osdep.h | 3 ---
>>  1 file changed, 3 deletions(-)
> 
> Please prefix staging drivers with "staging:".

Ok, will fix and resubmit.

-- 
Luca
