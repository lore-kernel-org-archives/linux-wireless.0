Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:33307 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612AbaJWT24 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2014 15:28:56 -0400
Received: by mail-oi0-f46.google.com with SMTP id h136so1209809oig.5
        for <linux-wireless@vger.kernel.org>; Thu, 23 Oct 2014 12:28:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1414085934.228950.182543717.6FA0F16D@webmail.messagingengine.com>
References: <1413463736.1316541.179720977.4FD32021@webmail.messagingengine.com>
	<1413510814.22769.6.camel@dcbw.local>
	<1413751717.2510219.180809145.0E693C29@webmail.messagingengine.com>
	<CANUX_P2RHVRorVABRfWVg39d4D8dj35v3fBpY3=3jvQ1U+mfEA@mail.gmail.com>
	<1413783023.2710583.180921653.10DFFCEE@webmail.messagingengine.com>
	<CANUX_P0Q7cNeBzQa=2WVZFJXPTLx8F6YQk9bGCf_3uYhc5RcGA@mail.gmail.com>
	<CANUX_P3EqgTX7cPJvQ3fWH1yijekE0G_8TiH2_OCS7nFASGtkA@mail.gmail.com>
	<1413789724.3063896.180943829.3F15F453@webmail.messagingengine.com>
	<CANUX_P1REqkSqN0dtak34OQ_pSGMtPvV3Vj61tW5wb1+n2A7mg@mail.gmail.com>
	<1413833365.2949853.181221645.22D54845@webmail.messagingengine.com>
	<CANUX_P3XzYBp7E=hScmc837TpuCr9VrxEYauG=sGMKfOCpX=qA@mail.gmail.com>
	<54461740.5000903@openwrt.org>
	<1413879792.3500640.181427549.198E9452@webmail.messagingengine.com>
	<54461AEF.7040304@openwrt.org>
	<54463CE9.3060400@gmail.com>
	<1413921415.3763081.181696749.20A0A495@webmail.messagingengine.com>
	<CANUX_P0LRRczVCSFR7RE5coaYFxwFXyqC90pdm=oVwEiEt-7zw@mail.gmail.com>
	<1414014805.4127522.182191541.14C8B4DF@webmail.messagingengine.com>
	<CANUX_P0tGagXsN6XCeb_itQehqD3O9fmqknU6iSMO432NQtATA@mail.gmail.com>
	<1414049448.32460.182326557.1A0A85A4@webmail.messagingengine.com>
	<CANUX_P3usjdccnsYPQXzKbJ1PTH91fasf6BpcsCRYZH_yq2tww@mail.gmail.com>
	<1414080125.164673.182502929.61AF3AB1@webmail.messagingengine.com>
	<CANUX_P2pJYNhLEMw=iQVe-CSbxqRDqOXL_gUZXxwpmAj2qj=FA@mail.gmail.com>
	<1414085934.228950.182543717.6FA0F16D@webmail.messagingengine.com>
Date: Thu, 23 Oct 2014 22:28:55 +0300
Message-ID: <CANUX_P0nK9AQEzYGfGFKEU_vVJ9fwOPmjGTCL--zmk+J4uCz4Q@mail.gmail.com> (sfid-20141023_212900_651346_F3F795C0)
Subject: Re: iwlwifi: Reason 7 periodic disconnect
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: =?UTF-8?Q?Lauren=C8=9Biu_Nicola?= <lnicola@dend.ro>
Cc: poma <pomidorabelisima@gmail.com>, Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001a113dd002400f4805061c135d
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--001a113dd002400f4805061c135d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 23, 2014 at 8:38 PM, Lauren=C8=9Biu Nicola <lnicola@dend.ro> wr=
ote:
> Okay. I'm running 3.17.1, so the line numbers might not be the ones
> you're expecting:
>
> patching file net/mac80211/mlme.c
> Hunk #1 succeeded at 128 (offset -1 lines).
> Hunk #2 succeeded at 137 (offset -1 lines).
> Hunk #3 succeeded at 1875 (offset -209 lines).
> Hunk #4 succeeded at 1886 (offset -207 lines).
> Hunk #5 succeeded at 1908 (offset -207 lines).
> Hunk #6 succeeded at 1924 (offset -244 lines).
>
> dmesg output is at https://bpaste.net/show/649277aaada8 .

can you please test the patch attached?

(remove the previous one first please)

>
> Laurentiu
>
> On Thu, Oct 23, 2014, at 19:46, Emmanuel Grumbach wrote:
>> On Thu, Oct 23, 2014 at 7:02 PM, Lauren=C8=9Biu Nicola <lnicola@dend.ro>
>> wrote:
>> > Sorry, but I only saw a two-line change [1] to
>> > `ieee80211_rx_mgmt_beacon` (which already had a log message). Am I
>> > missing something?
>> >
>> > [1] http://www.spinics.net/lists/linux-wireless/msg128340.html
>> >
>>
>> No - you are not. I did miss something...I forgot to attach the patch.
>> Here you go.
>>
>> > Laurentiu
>> >
>> > On Thu, Oct 23, 2014, at 11:07, Emmanuel Grumbach wrote:
>> >> On Thu, Oct 23, 2014 at 10:30 AM, Lauren=C8=9Biu Nicola <lnicola@dend=
.ro>
>> >> wrote:
>> >> > I did; the card still gets disconnected and the message doesn't sho=
w up
>> >> > in dmesg.
>> >> >
>> >>
>> >> You had *none* of the many prints I added in the log?
>> >>
>> >> That seems really weird...
>> >>
>> >> > Laurentiu
>> >> >
>> >> > On Thu, Oct 23, 2014, at 08:21, Emmanuel Grumbach wrote:
>> >> >> On Thu, Oct 23, 2014 at 12:53 AM, Lauren=C8=9Biu Nicola <lnicola@d=
end.ro>
>> >> >> wrote:
>> >> >> > Nope. It seems that code doesn't get executed when my issue occu=
rs (or
>> >> >> > in my five or ten minutes of uptime). I've seen
>> >> >> > `ieee80211_reset_ap_probe` get called by `ieee80211_rx_mgmt_prob=
e_resp`,
>> >> >> > but (if I'm not wrong) not on every disconnect.
>> >> >> >
>> >> >> > And as far as I can tell, force_cam is set to true.
>> >> >>
>> >> >> Can you please try with the patch attached and send the logs?
>> >> >> I again need MAC80211_MLME_DEBUG.
>> >> >>
>> >> >> Thanks.
>> >> >>
>> >> >> >
>> >> >> > Laurentiu
>> >> >> >
>> >> >> > On Wed, Oct 22, 2014, at 12:10, Emmanuel Grumbach wrote:
>> >> >> >> On Tue, Oct 21, 2014 at 10:56 PM, Lauren=C8=9Biu Nicola <lnicol=
a@dend.ro>
>> >> >> >> wrote:
>> >> >> >> > Yep! `scb_timeout` is 60 on my router.
>> >> >> >> >
>> >> >> >> > On Tue, Oct 21, 2014, at 14:00, poma wrote:
>> >> >> >> >> On 21.10.2014 10:35, Felix Fietkau wrote:
>> >> >> >> >> > On 2014-10-21 10:23, Lauren=C8=9Biu Nicola wrote:
>> >> >> >> >> >> It's an ASUS RT-N66U running NEWD-2/K3X from r24160.
>> >> >> >> >> > This is a Broadcom based device, so it should behave in th=
e same way as
>> >> >> >> >> > other APs/Routers running the Broadcom drivers.
>> >> >> >> >> > The driver should only send Reason 7 when receiving a PS-P=
oll, BlockAck,
>> >> >> >> >> > BlockAckReq or Action frame from a station that's not asso=
ciated, so
>> >> >> >> >> > probably it has already kicked out your iwlwifi client ear=
lier. Not sure
>> >> >> >> >> > why that doesn't show up in the log though.
>> >> >> >> >> >
>> >> >> >> >>
>> >> >> >> >> Whether this might refer to the Station Control Block Timeou=
t value
>> >> >> >> >>
>> >> >> >> >> http://www.dd-wrt.com/wiki/index.php/Wl#scb_timeout
>> >> >> >> >> ...
>> >> >> >> >> scb_timeout
>> >> >> >> >>
>> >> >> >> >> AP only: inactivity timeout value for authenticated stas
>> >> >> >> >>
>> >> >> >>
>> >> >> >> Actually, mac80211 should be probing the AP every 30 seconds bu=
t a
>> >> >> >> beacon might abort the probe...
>> >> >> >> Can you try something like this:
>> >> >> >>
>> >> >> >> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
>> >> >> >> index 75df184..c9db7cf 100644
>> >> >> >> --- a/net/mac80211/mlme.c
>> >> >> >> +++ b/net/mac80211/mlme.c
>> >> >> >> @@ -3295,7 +3295,8 @@ static void ieee80211_rx_mgmt_beacon(stru=
ct
>> >> >> >> ieee80211_sub_if_data *sdata,
>> >> >> >>         if (ifmgd->flags & IEEE80211_STA_CONNECTION_POLL) {
>> >> >> >>                 mlme_dbg_ratelimited(sdata,
>> >> >> >>                                      "cancelling AP probe due t=
o a
>> >> >> >> received beacon\n");
>> >> >> >> -               ieee80211_reset_ap_probe(sdata);
>> >> >> >> +               pr_err("Not cancelling the probe to make sure t=
he AP
>> >> >> >> hears us from time to time\n");
>> >> >> >> +               //ieee80211_reset_ap_probe(sdata);
>> >> >> >>         }
>> >> >> >>
>> >> >> >>         /*
>> >> >> >>
>> >> >> >>
>> >> >> >>
>> >> >> >> >>
>> >> >> >> >> poma
>> >> >> >> >>
>> >> >> >> >>
>> >> >> >> >> --
>> >> >> >> >> To unsubscribe from this list: send the line "unsubscribe li=
nux-wireless"
>> >> >> >> >> in
>> >> >> >> >> the body of a message to majordomo@vger.kernel.org
>> >> >> >> >> More majordomo info at  http://vger.kernel.org/majordomo-inf=
o.html
>> >> >> >> --
>> >> >> >> To unsubscribe from this list: send the line "unsubscribe linux=
-wireless"
>> >> >> >> in
>> >> >> >> the body of a message to majordomo@vger.kernel.org
>> >> >> >> More majordomo info at  http://vger.kernel.org/majordomo-info.h=
tml
>> >> >> --
>> >> >> To unsubscribe from this list: send the line "unsubscribe linux-wi=
reless"
>> >> >> in
>> >> >> the body of a message to majordomo@vger.kernel.org
>> >> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess"
>> >> in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Email had 1 attachment:
>> + PROBE.patch
>>   3k (application/octet-stream)

--001a113dd002400f4805061c135d
Content-Type: application/octet-stream; name="a.patch"
Content-Disposition: attachment; filename="a.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i1mi6g7r0

ZGlmZiAtLWdpdCBhL25ldC9tYWM4MDIxMS9tbG1lLmMgYi9uZXQvbWFjODAyMTEvbWxtZS5jCmlu
ZGV4IDJkZTg4NzAuLjkxNzM3MWQgMTAwNjQ0Ci0tLSBhL25ldC9tYWM4MDIxMS9tbG1lLmMKKysr
IGIvbmV0L21hYzgwMjExL21sbWUuYwpAQCAtMTkzMywyMyArMTkzMyw2IEBAIHN0YXRpYyB2b2lk
IGllZWU4MDIxMV9zZXRfZGlzYXNzb2Moc3RydWN0IGllZWU4MDIxMV9zdWJfaWZfZGF0YSAqc2Rh
dGEsCiAJc2RhdGEtPmVuY3J5cHRfaGVhZHJvb20gPSBJRUVFODAyMTFfRU5DUllQVF9IRUFEUk9P
TTsKIH0KIAotdm9pZCBpZWVlODAyMTFfc3RhX3J4X25vdGlmeShzdHJ1Y3QgaWVlZTgwMjExX3N1
Yl9pZl9kYXRhICpzZGF0YSwKLQkJCSAgICAgc3RydWN0IGllZWU4MDIxMV9oZHIgKmhkcikKLXsK
LQkvKgotCSAqIFdlIGNhbiBwb3N0cG9uZSB0aGUgbWdkLnRpbWVyIHdoZW5ldmVyIHJlY2Vpdmlu
ZyB1bmljYXN0IGZyYW1lcwotCSAqIGZyb20gQVAgYmVjYXVzZSB3ZSBrbm93IHRoYXQgdGhlIGNv
bm5lY3Rpb24gaXMgd29ya2luZyBib3RoIHdheXMKLQkgKiBhdCB0aGF0IHRpbWUuIEJ1dCBtdWx0
aWNhc3QgZnJhbWVzIChhbmQgaGVuY2UgYWxzbyBiZWFjb25zKSBtdXN0Ci0JICogYmUgaWdub3Jl
ZCBoZXJlLCBiZWNhdXNlIHdlIG5lZWQgdG8gdHJpZ2dlciB0aGUgdGltZXIgZHVyaW5nCi0JICog
ZGF0YSBpZGxlIHBlcmlvZHMgZm9yIHNlbmRpbmcgdGhlIHBlcmlvZGljIHByb2JlIHJlcXVlc3Qg
dG8gdGhlCi0JICogQVAgd2UncmUgY29ubmVjdGVkIHRvLgotCSAqLwotCWlmIChpc19tdWx0aWNh
c3RfZXRoZXJfYWRkcihoZHItPmFkZHIxKSkKLQkJcmV0dXJuOwotCi0JaWVlZTgwMjExX3N0YV9y
ZXNldF9jb25uX21vbml0b3Ioc2RhdGEpOwotfQotCiBzdGF0aWMgdm9pZCBpZWVlODAyMTFfcmVz
ZXRfYXBfcHJvYmUoc3RydWN0IGllZWU4MDIxMV9zdWJfaWZfZGF0YSAqc2RhdGEpCiB7CiAJc3Ry
dWN0IGllZWU4MDIxMV9pZl9tYW5hZ2VkICppZm1nZCA9ICZzZGF0YS0+dS5tZ2Q7CkBAIC0xOTc1
LDEzICsxOTU4LDI3IEBAIHN0YXRpYyB2b2lkIGllZWU4MDIxMV9yZXNldF9hcF9wcm9iZShzdHJ1
Y3QgaWVlZTgwMjExX3N1Yl9pZl9kYXRhICpzZGF0YSkKIAkgKi8KIAlpZWVlODAyMTFfc3RhX3Jl
c2V0X2JlYWNvbl9tb25pdG9yKHNkYXRhKTsKIAotCW1vZF90aW1lcigmaWZtZ2QtPmNvbm5fbW9u
X3RpbWVyLAotCQkgIHJvdW5kX2ppZmZpZXNfdXAoamlmZmllcyArCi0JCQkJICAgSUVFRTgwMjEx
X0NPTk5FQ1RJT05fSURMRV9USU1FKSk7CiBvdXQ6CiAJbXV0ZXhfdW5sb2NrKCZsb2NhbC0+bXR4
KTsKIH0KIAordm9pZCBpZWVlODAyMTFfc3RhX3J4X25vdGlmeShzdHJ1Y3QgaWVlZTgwMjExX3N1
Yl9pZl9kYXRhICpzZGF0YSwKKwkJCSAgICAgc3RydWN0IGllZWU4MDIxMV9oZHIgKmhkcikKK3sK
KwkvKgorCSAqIFdlIGNhbiBwb3N0cG9uZSB0aGUgbWdkLnRpbWVyIHdoZW5ldmVyIHJlY2Vpdmlu
ZyB1bmljYXN0IGZyYW1lcworCSAqIGZyb20gQVAgYmVjYXVzZSB3ZSBrbm93IHRoYXQgdGhlIGNv
bm5lY3Rpb24gaXMgd29ya2luZyBib3RoIHdheXMKKwkgKiBhdCB0aGF0IHRpbWUuIEJ1dCBtdWx0
aWNhc3QgZnJhbWVzIChhbmQgaGVuY2UgYWxzbyBiZWFjb25zKSBtdXN0CisJICogYmUgaWdub3Jl
ZCBoZXJlLCBiZWNhdXNlIHdlIG5lZWQgdG8gdHJpZ2dlciB0aGUgdGltZXIgZHVyaW5nCisJICog
ZGF0YSBpZGxlIHBlcmlvZHMgZm9yIHNlbmRpbmcgdGhlIHBlcmlvZGljIHByb2JlIHJlcXVlc3Qg
dG8gdGhlCisJICogQVAgd2UncmUgY29ubmVjdGVkIHRvLgorCSAqLworCWlmIChpc19tdWx0aWNh
c3RfZXRoZXJfYWRkcihoZHItPmFkZHIxKSkKKwkJcmV0dXJuOworCisJaWVlZTgwMjExX3Jlc2V0
X2FwX3Byb2JlKHNkYXRhKTsKK30KKwogdm9pZCBpZWVlODAyMTFfc3RhX3R4X25vdGlmeShzdHJ1
Y3QgaWVlZTgwMjExX3N1Yl9pZl9kYXRhICpzZGF0YSwKIAkJCSAgICAgc3RydWN0IGllZWU4MDIx
MV9oZHIgKmhkciwgYm9vbCBhY2spCiB7Cg==
--001a113dd002400f4805061c135d--
