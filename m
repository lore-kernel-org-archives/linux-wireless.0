Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:54814 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab3GDT3b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jul 2013 15:29:31 -0400
Received: by mail-wg0-f50.google.com with SMTP id k14so1422078wgh.29
        for <linux-wireless@vger.kernel.org>; Thu, 04 Jul 2013 12:29:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51D5BD9D.5020604@broadcom.com>
References: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
 <1372899889-19183-43-git-send-email-mcgrof@do-not-panic.com> <51D5BD9D.5020604@broadcom.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Fri, 5 Jul 2013 00:59:09 +0530
Message-ID: <CABPxzYLD3xp9vyTA42PsCdNo1qAm4+X4OrqFTN70-aGvO52FeQ@mail.gmail.com> (sfid-20130704_212934_292040_FCD18AE5)
Subject: Re: [RFC 42/53] wireless-regdb: ID, Indonesia - enable 5 GHz and VHT80
To: Arend van Spriel <arend@broadcom.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linville@tuxdriver.com, wireless-regdb@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 4, 2013 at 11:53 PM, Arend van Spriel <arend@broadcom.com> wrote:
>
> On 07/04/2013 03:04 AM, Luis R. Rodriguez wrote:
>>
>> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
>>
>> Pursuant to:
>>
>> http://www.postel.go.id/content/ID/regulasi/standardisasi/kepdir/bwa%205,8%20ghz.pdf,
>>
>> provide a 5GHz rule for Indonesian regulatory domain. QCA has
>> also verified VHT80 can be enabled. Patch originally posted by
>> Paul Stewart <pstew@chromium.org>, I just modified to enable 80 MHz
>> bandwidth.
>
>
> Hi Luis,
>
> Is it just me or did you make a typo. Should '@ 20' be '@ 80' ?

But as per the document shared above the maximum BW allowed is 20MHz only, no?
So is the VHT80 tested by QCA compliant to the reg rules?
