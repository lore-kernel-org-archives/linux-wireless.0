Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-gw3.mailanyone.net ([208.101.34.33]:59163 "EHLO
	smtp-gw3.mailanyone.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753117AbZFVTMh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2009 15:12:37 -0400
Message-ID: <4A3FD26C.4070503@cheek.com>
Date: Mon, 22 Jun 2009 14:50:20 -0400
From: Joseph Cheek <joseph@cheek.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	parag.warudkar@gmail.com, gaurav.jauhar@atheros.com,
	rootkit85@yahoo.it, ath9k-devel@lists.ath9k.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: Re: [ath9k-devel] Pending ath9k bugs June, 2009
References: <43e72e890906220847u4faaeb2paa15365360c3c080@mail.gmail.com>
In-Reply-To: <43e72e890906220847u4faaeb2paa15365360c3c080@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I will attempt to repro my xmit hangs bugs on today's wireless testing. 
I haven't submitted a kernel.org bug on it, just mentioned it on the
ath9k list several times.  I can submit a kernel.org bug for it tho,
assuming it repros (I've had it ever since Christmas, but who knows?).

Joseph Cheek

Luis R. Rodriguez wrote:
> We're down to 2 kernel.org bug reports for ath9k:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=13581
> "ath9k doesn't work with newer kernels"
> This is a regression between 2.6.29 and 2.6.30, someone needs to look at this.
>
> http://bugzilla.kernel.org/show_bug.cgi?id=13141
> "AR5008/DWA-552 - Very slow"
> Patches have been supplied, needs user feedback.
>
> If you are aware of any other issues please do report.
>
>   Luis
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>
>   
